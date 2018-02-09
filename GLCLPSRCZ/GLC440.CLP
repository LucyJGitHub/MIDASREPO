/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Initial group job program')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - GENERAL LEDGER MODULE                           */
/*                                                                   */
/*       GLC440 - CONTROLLING PROGRAM FOR GROUP JOB SESSION          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*           1988,1989                                               */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSF002             Date 11Aug03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      185817             Date 31Jan01              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      153379             DATE 15Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      124565             DATE 26FEB98              */
/*                      060468             DATE 21JAN94              */
/*                      S01405             DATE 08DEC92              */
/*                      E28500             DATE 24SEP91              */
/*                      S01194             DATE 09DEC89              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSF002 - Global layer.                                      */
/*                - Replace previous ZMITEM data with the new unique */
/*                  code. Remove the command which sets up SFC0600   */
/*                  as the program to be called when Attention Key   */
/*                  is pressed since SFC0600 is made redundant       */
/*                  already.                                         */
/*       185817 - Increase the number of retry when checking the     */
/*                group job to avoid program error message CPF1306.  */
/*       153379 - The GLCJOB group session SETANTPGM is SFC0600      */
/*                (the manual instruction) rather than the session   */
/*                manager SETATNPGM SFC4460, so GLCJOB group jobs    */
/*                are not open to session manager due to limitation  */
/*                problems. (Fix 122745.)                            */
/*       124565 - Transfer ZMITEM DTAARA content into *GDA to make   */
/*                possible enquiry on FT movement (see also GL4442). */
/*       060468 - Initialise *GDA before and after use for account   */
/*                movements enquiry group jobs.                      */
/*       S01405 - Amend use of group jobs to allow for session       */
/*                manager.                                           */
/*       E28500 - Attempt retry of CHGGRPA(*NONE) if other group     */
/*                jobs are still ending.                             */
/*       S01194 - New standing data                                  */
/*                                                                   */
/*********************************************************************/
/**/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&RTNCDE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&COUNT)   TYPE(*DEC)  LEN(3 0) VALUE(1)
             DCL        VAR(&POINTER) TYPE(*DEC)  LEN(5 0) VALUE(1)
 
             DCL        VAR(&GRPLIST) TYPE(*CHAR) LEN(1056)
             DCL        VAR(&GRPNUM)  TYPE(*DEC)  LEN(3 0)
             DCL        VAR(&GRPJOBNAM) TYPE(*CHAR) LEN(10)           /*S01405*/
             DCL        VAR(&GRPJOBCNT) TYPE(*DEC) LEN(3 0)           /*S01405*/
 
             DCL        VAR(&JOBLOG)  TYPE(*CHAR) LEN(7) VALUE('*LIST')
             DCL        VAR(&TEST)    TYPE(*CHAR) LEN(10)
/*           DCL     VAR(&MEM) TYPE(*CHAR) LEN(44)              */    /*S01194*/
             DCL     VAR(&MEM) TYPE(*CHAR) LEN(50)                    /*S01194*/
             DCL        VAR(&COUNT2)   TYPE(*DEC)  LEN(2 0) VALUE(1)  /*E28500*/
/**********  DCL        VAR(&MITEM) TYPE(*CHAR) LEN(9)                         /*124565*/ /*CSF002*/
             DCL        VAR(&MITEM) TYPE(*CHAR) LEN(10)                                   /*CSF002*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
/*************************************************************/
/**                                                          */
/**  Setup a Group Job session and immediately transfer to   */
/**  the first enquiry program.  Control will only return    */
/**  to this program when a return is to be made back to the */
/**  midas menus.                                            */
/**                                                          */
/*************************************************************/
 
             CHGJOB     SWS(00000000)
/*********** CHGGRPA    GRPJOB(GLCJOB0) TEXT('Group Control program')   S01405*/
             RTVGRPA    GRPJOB(&GRPJOBNAM) GRPJOBCNT(&GRPJOBCNT) +
                          /*S01405*/
             MONMSG     MSGID(CPF0000)                                /*S01405*/
             IF         COND(&GRPJOBCNT *EQ 0) THEN(DO)               /*S01405*/
              CHGGRPA   GRPJOB(GLCJOB0) TEXT('Group Control program') /*S01405*/
              CHGDTAARA  DTAARA(*GDA (450 10)) VALUE(GLCJOB0)         /*S01405*/
/**********   SETATNPGM  PGM(SFC0600)                                          /*S01405*/ /*CSF002*/
             ENDDO                                                    /*S01405*/
             ELSE       CMD(DO)                                       /*S01405*/
              CHGDTAARA  DTAARA(*GDA (450 10)) VALUE(&GRPJOBNAM)      /*S01405*/
              SETATNPGM PGM(SFC4460)                                  /*S01405*/
             ENDDO                                                    /*S01405*/
 
             CHGDTAARA  DTAARA(*GDA (2 51)) VALUE(' ')                /*060468*/
/**********  RTVDTAARA  DTAARA(ZMITEM (1 9)) RTNVAR(&MITEM)                    /*124565*/ /*CSF002*/
/**********  CHGDTAARA  DTAARA(*GDA (101 9)) VALUE(&MITEM)                     /*124565*/ /*CSF002*/
             RTVDTAARA  DTAARA(ZMITEM (1 10)) RTNVAR(&MITEM)                              /*CSF002*/
             CHGDTAARA  DTAARA(*GDA (101 10)) VALUE(&MITEM)                               /*CSF002*/
             TFRGRPJOB  GRPJOB(GLCJOB1) INLGRPPGM(GLC441) TEXT('Acc & +
                          Stmt Details')
 
/*************************************************************/
/**                                                          */
/**  When a return has been made to this program consider    */
/**  if an error occured in any of the enquiry programs.     */
/**  And if so display an appropriate error message          */
/**                                                          */
/*************************************************************/
 
/*********** RTVDTAARA  DTAARA(*GDA (1 1)) RTNVAR(&RTNCDE)             S01405*/
             RTVDTAARA  DTAARA(*GDA (460 1)) RTNVAR(&RTNCDE) /*S01405*/
 
             IF         COND(&RTNCDE *EQ '1') THEN(DO)
                RTVDTAARA  DTAARA(*GDA (134 44)) RTNVAR(&MEM)
/*              CHGDTAARA  DTAARA(LDA (134 44)) VALUE(&MEM)*/         /*S01194*/
                CHGDTAARA  DTAARA(LDA (134 50)) VALUE(&MEM)           /*S01194*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                ENDDO
 
             IF         COND(&RTNCDE *EQ '2') THEN(DO)
             SNDPGMMSG  MSG('Account Enquiries ended in ERROR - see +
                          joblogs for GLCJOB1/2/3/4 to determine +
                          error') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                ENDDO
 
             IF         COND(&RTNCDE *EQ '3') THEN(DO)
             SNDPGMMSG  MSG('Transfer between Enquiries or Data Areas +
                          was unsuccessful - see program dumps to +
                          determine error') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                ENDDO
 
/*************************************************************/
/**                                                          */
/**   Before a return is made to the midas menus all spawned */
/**   group jobs must be terminated and the group job        */
/**   session ended.                                         */
/**                                                          */
/**                                                          */
/*************************************************************/
 
 GRPEND:     IF         COND(&RTNCDE *EQ '0') THEN(CHGVAR +
                          VAR(&JOBLOG) VALUE('*NOLIST'))
 
             RTVGRPA    GRPJOBL(&GRPLIST) +
                          GRPJOBCNT(&GRPNUM)
 
 
 LOOP:       IF         COND(&COUNT *LT &GRPNUM) THEN(DO)
                CHGVAR     VAR(&POINTER) VALUE(&POINTER + 66)
 /* ONLY END THOSE JOBS STARTED BY THE LINKED ENQUIRIES               /*S01405*/
             IF         COND(%SST(&GRPLIST &POINTER 6) *EQ 'GLCJOB') +
                          THEN(DO)                                    /*S01405*/
              ENDGRPJOB GRPJOB(%SST(&GRPLIST &POINTER 10)) LOG(&JOBLOG)
             CHGDTAARA  DTAARA(*GDA (1 299)) VALUE(' ')               /*153379*/
                              ENDDO                                   /*S01405*/
                CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
                GOTO       CMDLBL(LOOP)
                ENDDO
             RTVDTAARA  DTAARA(*GDA (450 10)) RTNVAR(&GRPJOBNAM) +
                          /*S01405*/
             IF         COND(&GRPJOBNAM *NE 'GLCJOB0') THEN(GOTO +
                          CMDLBL(RETRN))
 
/***LOOP2:IF COND(&COUNT2 *GT 12)THEN(GOTO CMDLBL(ABNOR)) */   /*E28500*185817*/
 LOOP2:      IF         COND(&COUNT2 *GT 50) THEN(GOTO CMDLBL(ABNOR)) /*185817*/
             CHGGRPA    GRPJOB(*NONE)
 
/* If jobs are still ending then retry the CHGGRPA command           */
             MONMSG     MSGID(CPF1306) EXEC(DO)                       /*E28500*/
                  DLYJOB     DLY(10)                                  /*E28500*/
                  CHGVAR     VAR(&COUNT2) VALUE(&COUNT2 + 1)          /*E28500*/
                  GOTO       CMDLBL(LOOP2)                            /*E28500*/
             ENDDO                                                    /*E28500*/
 
/*********** RETURN                                                   /*S01405*/
 RETRN:      RETURN                                                   /*S01405*/
 
/*************************************************************/
/**                                                          */
/**   If an error occurs within this program then dump this  */
/**   program and return via processing at LOOP if group     */
/**   job session is active                                  */
/**                                                          */
/*************************************************************/
 
 ABNOR:      SNDPGMMSG  MSG('Error occured in program GLC440 - See +
                          program dump listing') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
 
             DMPCLPGM
 
             RTVGRPA    GRPJOB(&TEST)
/************IF COND(&TEST *EQ '*NONE  ') THEN(GOTO CMDLBL(GRPEND))*/ /*060468*/
             IF         COND(&TEST *NE '*NONE     ') +
                             THEN(GOTO CMDLBL(GRPEND))                /*060468*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
