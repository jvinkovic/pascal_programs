Program RunExe;

{$M 16000, 0, 0}
{$S+,D+,R+,B-}

{ For runing a program we need to setup ram first }

Uses
   { Use dos unit because functions Exec and GetEnv }
   Dos;

Type
   { the most common is string of 79 charrs }
   TStrCmd = String [ 79 ];

{ Main program for runing command line }
Procedure ExecCmd ( sCmdLine : TStrCmd );
Var
   nErr : LongInt;      { Value of function DosError    }
   sCmd : String;       { path to Command.com which is showing GetEnv }
Begin
   { step 1. need to get path to Command.Com file                    }
   sCmd := GetEnv ( 'COMSPEC' );

   { step 2. IF string of comand line is not empty we need  }
   {     parameter,  swich /C which is neccessery      }
   {     Command.Com /C                                        }
   If sCmdLine <> ''
   Then
      sCmdLine := '/C ' + sCmdLine;

   { step 3. Saving pointer for part of ram memory (at the moment)         }
   SwapVectors;

   { step 4. Running command line Command.com /C CmdLine     }
   Exec ( sCmd, sCmdLine );

   { step 5. rollback pointer          }
   SwapVectors;

   { K6. checking rollback value of running command        }
   nErr := DosError;
   If nErr <> 0
   Then
      WriteLn ( 'Mistake: ', nErr, ' - cant be done ', sCmdLine );
End;

Procedure RunExe_TEST;
Var
   sCmdLine : TStrCmd;
Begin

   { step 1. Test order DIR                                     }
   sCmdLine := 'Dir';
   ExecCmd ( sCmdLine );

   { step 2. Test calling protram NOTEPAD                      }
   sCmdLine := 'NOTEPAD.EXE';
   ExecCmd ( sCmdLine );

   { step 3. Test calling program TweakUI from Control Panel   }
   sCmdLine := 'Rundll32.exe shell32.dll, Control_RunDLL TweakUI.cpl';
   ExecCmd ( sCmdLine );

   { step 4. Notification about end of TEST example                     }
   WriteLn  ('End of test example');
   ReadLn;

End;

BEGIN
   { Connecting TEST from subprogram RunExe_TEST        }
   RunExe_TEST;
END.
