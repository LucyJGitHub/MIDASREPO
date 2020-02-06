/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Cashier TCP/IP listener ENDJOB process.')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Cashier Interface Module                            */
/*                                                                   */
/*       REC4590 - Midas Cashier TCP/IP Listener ENDJOB Module.      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CRT007             Date 14Jan02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      194002  *CREATE    Date 06Jul01              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CRT007 - Close new Heartbeat job, too.                      */
/*       194002 - Multiple Jobs issue.  ENDJOB if error.             */
/*                                                                   */
/*********************************************************************/
     PGM PARM(&BRC)
 
               DCL        VAR(&BRC) TYPE(*CHAR) LEN(3)
               DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
               /* Job  Parameters*/
               DCL        VAR(&SUBSYST) TYPE(*CHAR) LEN(10)
               DCL        VAR(&JOBQUAL) TYPE(*CHAR) LEN(28)
               DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)
               DCL        VAR(&JOBUSER) TYPE(*CHAR) LEN(10)
               DCL        VAR(&JOBNUMB) TYPE(*CHAR) LEN(6)
               /* User Space Parameters*/
               DCL        VAR(&USRSPC) TYPE(*CHAR) LEN(20) +
                            VALUE('ACTSSBRC  QTEMP     ')
               DCL        VAR(&USSPNM) TYPE(*CHAR) LEN(10)
               DCL        VAR(&SIZEUSR) TYPE(*CHAR) LEN(4)
               /* Retrieve Header Parameters*/
               DCL        VAR(&DATHEAD) TYPE(*CHAR) LEN(16)
               /* Loop Job Active in System Parameters*/
               DCL        VAR(&STRBIN) TYPE(*CHAR) LEN(4)
               DCL        VAR(&TOTBIN) TYPE(*CHAR) LEN(4)
               DCL        VAR(&OFFDEC) TYPE(*DEC) LEN(6) VALUE(0)
               DCL        VAR(&NBLDEC) TYPE(*DEC) LEN(6) VALUE(0)
               DCL        VAR(&SZEDEC) TYPE(*DEC) LEN(6) VALUE(0)
               DCL        VAR(&DATA) TYPE(*CHAR) LEN(60)
               DCL        VAR(&CPT) TYPE(*DEC) LEN(3 0)
               /* Job and Subsystem Description Parameters*/
               DCL        VAR(&JOBD) TYPE(*CHAR) LEN(134)
               DCL        VAR(&INTJBNB) TYPE(*CHAR) LEN(16)
            MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Retrieve Subsystem of Current Job and Change its Attributes      */
 
             CALL       PGM(QUSRJOBI) PARM(&JOBD X'00000086' +
                          'JOBI0200' '*                         ' +
                          &INTJBNB)
             CHGVAR     VAR(&SUBSYST) VALUE(%SST(&JOBD 63 10))
             CHGVAR     VAR(&PREFIX) VALUE(%SST(&SUBSYST 2 2))
 
/** Set up user space name as Branch(3a), System prefix(2a) and'ACT'*/
/* Create User Space for List of Active job in Subsystem            */
      CHGVAR &USSPNM  VALUE('ACT' *CAT &PREFIX *CAT &BRC)
      CHGVAR &USRSPC  VALUE(&USSPNM *CAT 'QTEMP     ')
/**/
             DLTUSRSPC  USRSPC(&USSPNM)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%BIN(&SIZEUSR)) VALUE(32567)
             CALL       PGM(QUSCRTUS) PARM(&USRSPC '          ' +
                         &SIZEUSR ' ' '*USE    ' 'LIST OF ACTIVE +
                          JOB IN SUSBSYSTEM')
 MAINLOOP:
 
 /* Fill User Space with List of Active Job                         */
              CALL       PGM(QUSLJOB) PARM(&USRSPC 'JOBL0100' +
                           '*ALL      *ALL      *ALL  ' '*ACTIVE   ')
 
 /* Read Header for Information on User Space                        */
 
              CHGVAR     VAR(&DATHEAD) VALUE(' ')
              CALL       PGM(QUSRTVUS) PARM(&USRSPC X'0000007D' +
                           X'00000010' &DATHEAD)
 
 
              CHGVAR     VAR(&OFFDEC)    VALUE(%BIN(&DATHEAD  1 4))
              CHGVAR     VAR(&NBLDEC)    VALUE(%BIN(&DATHEAD  9 4))
              CHGVAR     VAR(&SZEDEC)    VALUE(%BIN(&DATHEAD 13 4))
              CHGVAR     VAR(&TOTBIN)    VALUE(%SST(&DATHEAD 13 4))
 
              CHGVAR     VAR(&OFFDEC) VALUE(&OFFDEC + 1)
              CHGVAR     VAR(&CPT) VALUE(1)
  LOOP:       IF         COND(&CPT *GT &NBLDEC) THEN(GOTO +
                           CMDLBL(ENDLOOP))
              CHGVAR     VAR(%BIN(&STRBIN)) VALUE(&OFFDEC)
 
 /* Read Job by Job                                                 */
 
              CALL       PGM(QUSRTVUS) PARM(&USRSPC &STRBIN &TOTBIN +
                           &DATA)
 
/* Check Subsystem of Job                                            */
 
             CHGVAR     VAR(&JOBQUAL) VALUE(%SST(&DATA 21 6) *TCAT +
                          '/' *TCAT %SST(&DATA 11 10) *TCAT '/' +
                          *TCAT %SST(&DATA 1 10))
             CHGVAR     VAR(&INTJBNB) VALUE(%SST(&DATA 27 16))
             CALL       PGM(QUSRJOBI) PARM(&JOBD X'00000086' +
                          'JOBI0200' '*INT                      ' +
                          &INTJBNB)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(NOTFOUND))
/**/
             IF         COND(%SST(&JOBD 63 10) *EQ &SUBSYST *AND +
                          %SST(&JOBD 61 1) *EQ 'B') THEN(DO)
             CHGVAR     VAR(&JOBNAME) VALUE(%SST(&DATA 1 10))
             CHGVAR     VAR(&JOBUSER) VALUE(%SST(&DATA 11 10))
             CHGVAR     VAR(&JOBNUMB) VALUE(%SST(&DATA 21 6))
/* Pick out the Cashier, Branch Monitor, Forwarding and Branch      */
/* Status jobs and shut them all down (to free the socket).         */
/* Also Heartbeat job                                                   CRT007*/
/*********** IF         COND(%SST(&JOBNAME 8 3) *EQ &BRC *AND +         CRT007*/
/***********              %SST(&JOBNAME 1 3) *EQ 'CSH' +                CRT007*/
/***********            *OR %SST(&JOBNAME 8 3) *EQ &BRC *AND +          CRT007*/
/***********              %SST(&JOBNAME 1 6) *EQ 'BRANCH' +             CRT007*/
/***********            *OR %SST(&JOBNAME 8 3) *EQ &BRC *AND +          CRT007*/
/***********              %SST(&JOBNAME 1 6) *EQ 'FORWRD'  +            CRT007*/
/***********            *OR %SST(&JOBNAME 8 3) *EQ &BRC *AND +          CRT007*/
/***********              %SST(&JOBNAME 1 6) *EQ 'BMSTAT')  +           CRT007*/
/***********  THEN(DO)                                                  CRT007*/
             IF         COND(%SST(&JOBNAME 8 3) *EQ &BRC *AND +
                          %SST(&JOBNAME 1 3) *EQ 'CSH' +
                        *OR %SST(&JOBNAME 8 3) *EQ &BRC *AND +
                          %SST(&JOBNAME 1 6) *EQ 'BRANCH' +
                        *OR %SST(&JOBNAME 8 3) *EQ &BRC *AND +
                          %SST(&JOBNAME 1 6) *EQ 'FORWRD'  +
                        *OR %SST(&JOBNAME 8 3) *EQ &BRC *AND +
                          %SST(&JOBNAME 1 6) *EQ 'BMSTAT'   +
                        *OR %SST(&JOBNAME 8 3) *EQ &BRC *AND +
                          %SST(&JOBNAME 1 6) *EQ 'HEARTB')   +
              THEN(DO)                                                /*CRT007*/
  SNDUSRMSG MSG('JOB ' *CAT &JOBNUMB *BCAT &JOBUSER *BCAT &JOBNAME +
               *CAT  ' ENDED') MSGTYPE(*INFO) TOMSGQ(MOPERQ)
          ENDJOB     JOB(&JOBNUMB/&JOBUSER/&JOBNAME) OPTION(*IMMED)
             MONMSG CPF1321  /* Job not found */
             MONMSG CPF1362  /* Job has already completed */
             MONMSG CPF1344  /* Not authorised to control job */
             MONMSG CPF135A  /* Errors on ENDJOB */
             MONMSG CPF136A  /* Job not active */
             MONMSG CPF136B  /* Job in use */
             MONMSG CPF1361  /* Job already ending *IMMED */
             MONMSG CPF1360  /* ENDJOBABN in progress */
             MONMSG CPF1363  /* Job already ending *CNTRLD */
             ENDDO
/* /COPY for extra actions                                           */
             ENDDO
 
NOTFOUND:    CHGVAR     VAR(&CPT) VALUE(&CPT + 1)
             CHGVAR     VAR(&OFFDEC) VALUE(&OFFDEC + &SZEDEC)
             GOTO       CMDLBL(LOOP)
 
ENDLOOP:    CALL       PGM(RE4590) PARM(&BRC)
            MONMSG     MSGID(CPF0000)
 
             GOTO       CMDLBL(END)
/*          */
/*          */
/* Completed*/
/*          */
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            REC4590 ended abnormally - see job log')   +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 END:
             DLTUSRSPC  USRSPC(&USSPNM)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
 
        ENDPGM
