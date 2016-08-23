     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PB Advise user of Jnl entry waiting accept.')
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  PBGLHELD - Midas - Trigger Program Parameters                *
      *                                                               *
      *  Function:  Advise user of Journal Entries                    *
      *             waiting for Acceptance                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CPB009  *CREATE    Date 12Sep02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CPB009 - PB Operator Message Handling                        *
      *           (PB Alerter - error tracking)                       *
      *                                                               *
      *****************************************************************
      /EJECT
      * DECLARE THE STRUCTURES THAT ARE TO BE PASSED INTO THIS PROGRAM.
 
     D PARM1           DS
      * Physical file name
     D  FNAME                        10
      * Physical file library
     D  LNAME                        10
      * Member name
     D  MNAME                        10
      * Trigger event 1=Ins, 2=Del, 3=Upd
     D  TEVEN                         1
      * Trigger time  1=After, 2=Before
     D  TTIME                         1
      * Commit lock level
     D  CMTLCK                        1
      * Reserved
     D  FILL1                         3
      * CCSID
     D  CCSID                         9B 0
      * Reserved
     D  FILL2                         8
      * Offset to the original record (Add 1!)
     D  OLDOFF                        9B 0
      * length of the original record
     D  OLDLEN                        9B 0
      * Offset to the original record null byte map (Add 1!)
     D  ONOFF                         9B 0
      * length of the null byte map
     D  ONLEN                         9B 0
      * Offset to the new record (Add 1!)
     D  NEWOFF                        9B 0
      * length of the new record
     D  NEWLEN                        9B 0
      * Offset to the new record null byte map (Add 1!)
     D  NNOFF                         9B 0
      * length of the null byte map
     D  NNLEN                         9B 0
      * Reserved
     D  RESV3                        16
      * Records
     D  RECS                      10000
 
      * Trigger Buffer Length
     D PARM2           DS
     D  LENG                          9B 0
 
      * Record to be inserted or new values
     D OUT             DS
     D Application                   15
     D Process                       30
     D Gravity                        1
     D Body                        3000
     D Status                         1
     D Front_id                      20
     D Inuse                          1
     D Title                        255
 
      * SET UP THE ENTRY PARAMETER LIST.
 
     C     *ENTRY        PLIST
     C     PARM1         PARM                    PARM1
     C     PARM2         PARM                    PARM2
 
     C                   EVAL      Application=*blanks
     C                   EVAL      Process=*blanks
     C                   EVAL      Gravity=*blanks
     C                   EVAL      Body=*blanks
     C                   EVAL      Title=*blanks
     C                   EVAL      Front_id  =*blanks
     C                   EVAL      Status  =*blanks
     C                   EVAL      Inuse  =*blanks
 
     C     TEVEN         IFEQ      '1'
     C     TEVEN         OREQ      '3'
     C                   EVAL      Status =  %SUBST(PARM1:NEWOFF+44:1)
     C                   EVAL      Inuse =  %SUBST(PARM1:NEWOFF+45:1)
     C                   EVAL      Front_id  =  %SUBST(PARM1:NEWOFF+177:20)
     C                   EVAL      Body= %SUBST(PARM1:NEWOFF+1:NEWLEN)
     c* Front office Id is expected to always be 20 first characters
     C                   EVAL      Title = 'Batch #: ' +
     C                                    %SUBST(PARM1:NEWOFF+1:3) +
     C                                    ' With Id ' + Front_id  +
     C                                    ' in: ' + LNAME +
     C                                    ' has been inserted or amended ' +
     C                                    'with status HELD'
     C                   EVAL      Title =  %SUBST(Title:1:254) + '*'
     C                   ENDIF
     C     TEVEN         IFEQ      '2'
     C*    TEVEN         OREQ      '3'
     C                   EVAL      Front_id  =  %SUBST(PARM1:OLDOFF+177:20)
     C                   EVAL      Body= %SUBST(PARM1:OLDOFF+1:OLDLEN)
     c* Front office Id is expected to always be 20 first characters
     C                   EVAL      Title = 'Batch #: ' +
     C                                    %SUBST(PARM1:OLDOFF+1:3) +
     C                                    ' With Id ' + Front_id  +
     C                                    ' in: ' + LNAME +
     C                                    ' has been Deleted '
     C                   EVAL      Title =  %SUBST(Title:1:254) + '*'
     C                   ENDIF
     C     Front_id      IFNE      *blanks
     C     Status        ANDEQ     'H'
     C     Inuse         ANDEQ     ' '
     C                   EVAL      Application= 'PBGLHELD'
     C                   EVAL      Process=FNAME
     C                   EVAL      Gravity=''
     C* Call Alerter Generator
     C                   CALL      'PBCALERTER'
     C                   PARM                    Gravity
     C                   PARM                    Application
     C                   PARM                    Process
     C                   PARM                    Title
     C                   PARM                    Body
     C                   END
     C     Front_id      IFNE      *blanks
     C     TEVEN         ANDEQ     '2'
     C                   EVAL      Application= 'PBGLHELD'
     C                   EVAL      Process=FNAME
     C                   EVAL      Gravity=''
     C* Call Alerter Generator
     C                   CALL      'PBCALERTER'
     C                   PARM                    Gravity
     C                   PARM                    Application
     C                   PARM                    Process
     C                   PARM                    Title
     C                   PARM                    Body
     C                   END
     C*
     C                   RETURN
