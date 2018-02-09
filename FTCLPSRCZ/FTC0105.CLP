/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Nostro transfers authorisation')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - FUNDS TRANSFER MODULE                               */
/*                                                                   */
/*       FTC0105    NOSTRO TRANSFER AUTHORISATION AND ENQUIRY        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CRE020             Date 20Jan04              */
/*                      CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CFT006             Date 06Sep99              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                       110242              DATE 07NOV96            */
/*                       084923              DATE  13APR95           */
/*                       042167              DATE  15APR93           */
/*                       S01117              DATE  24SEP90           */
/*                       S01194              DATE  07SEP90           */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       CFT006 - Addition of RFT and CCT id to SDFTFRPD (recompile) */
/*       110242  -  Change defaults for SBMJOB cmd to take *JOBD     */
/*       084923  -  If Auto Pay Receive generation is in effect, send*/
/*                  'MIDAS' message to MSTATUS to balance with       */
/*                  MIDASRMV CALL, which otherwise removes a message */
/*                  sent by another job.                             */
/*       042167  -  CL PROGRAM FOR RECORD LOCKING                    */
/*       S01117  -  RELEASE 10 MULTIBRANCHING CHANGES                */
/*       S01194  -  STANDING DATA CHANGES                            */
/*********************************************************************/
             PGM        PARM(&PREF &RETC)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**DCL   VAR(&MEM)   TYPE(*CHAR)   LEN(44)                           /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                /*S01194*/
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(15)
             DCL        VAR(&RETC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMD)  TYPE(*CHAR) LEN(1)
                                                                      /*042167*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*042167*/
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)               /*042167*/
             DCL        VAR(&TRNREF) TYPE(*CHAR) LEN(15)              /*042167*/
             DCL        VAR(&RINFOR) TYPE(*CHAR) LEN(80)              /*042167*/
             DCL        VAR(&PREF2)  TYPE(*CHAR) LEN(15)              /*042167*/
                                                                                          /*CRE020*/
/* Declare the variables to check the enhancements file */                                /*CRE020*/
                                                                                          /*CRE020*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                                                /*CRE020*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CRE020*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CRE020*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1) +
                          VALUE(' ')                                                      /*CRE020*/
                                                                                          /*CRE020*/
/*/COPY WNCPYSRC,FTC0105001                                          */
 
/**          DCLF       FILE(TABTB11)                                /*S01194*/
             DCLF       FILE(SDFTFRPD)                               /*S01194*/
 
   CHGJOB SWS(XXXXXX00)
                                                                                          /*CRE020*/
/* Check if enhancement CRE020 in installed */                                            /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&SARD) VALUE('CRE020')                                        /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&RTNCDE &OPTN &SARD &FMT)                      /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTNCDE *NE '       ' *AND &RTNCDE *NE +
                          '*NRF   ') THEN(GOTO CMDLBL(END))                               /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTNCDE *EQ '       ') THEN(CHGVAR +
                          VAR(&CRE020) VALUE('Y'))                                        /*CRE020*/
                                                                      /*042167*/
              CHGVAR     VAR(&PREF2) VALUE(&PREF)                     /*042167*/
                                                                      /*042167*/
 
/*  CALL PROGRAM & MONITOR FOR ERRORS                               */
 
             CALL       PGM(FT0105) PARM(&PREF &RETC)
   MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
              ROLLBACK
              SNDPGMMSG  MSG('Transaction Failed. Re-input necessary. +
                              Press Enter to Continue.') TOPGMQ(*EXT)
              GOTO END
   ENDDO
/* AUTOMATIC CALL OF PAY/RECEIVE INDICATOR - ONLY IF NOT LINKED */
/**/
             IF         COND(&PREF *EQ ' ') THEN(DO)
/**/
/**          RCVF       RCDFMT(TABTB11F)                             /*S01194*/
/**          IF         COND((&APYR = 'Y')) THEN(DO)                 /*S01194*/
/**          RTVDTAARA  DTAARA(LDA (178 1))   RTNVAR(&CMD)           /*S01194*/
             RCVF       RCDFMT(SDFTFRD0)                             /*S01194*/
             IF         COND((&BTAFTM = 'Y')) THEN(DO)               /*S01194*/
             RTVDTAARA  DTAARA(LDA (184 1))   RTNVAR(&CMD)           /*S01194*/
/**/
             IF         COND((&CMD = '3')) THEN(DO)
/**/                                                                 /*084923*/
             SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)                 /*084923*/
/*/COPY WNCPYSRC,FTC0105002                                          */
/**/
/************SBMJOB     JOB(FTC0630) JOBD(MBATCH) RTGDTA(*JOBD) +     /*110242*/
/*************            RQSDTA('CALL PGM(FTC0630) PARM('''' +       /*110242*/
/*************            '''' '''')') */                      /*S01117 110242*/
/************SBMJOB     JOB(FTC0630) JOBD(MBATCH) RTGDTA(*JOBD) +                         /*CPK014*/
/************             RQSDTA('CALL PGM(FTC0630) PARM('''' '''' +                      /*CPK014*/
/************             '''')') INLLIBL(*JOBD)                     /*110242*/           /*CPK014*/
/**                       RQSDTA('CALL PGM(FTC0630)')                /*S01117*/
/************SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +                           /*CPK014*/
/************             JOBD(MBATCH) RTGDTA(*JOBD) INLLIBL(*JOBD)   /*S01117*/          /*CPK014*/
/************SBMJOB     JOB(FTC0630) JOBD(MBATCH) USER(*JOBD) +                           /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL PGM(FTC0630) +                       /*CSC023*/
/************             PARM('''' '''' '''')') INLLIBL(*JOBD)                /*CPK014*/ /*CSC023*/
/************SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +                           /*CSC023*/
/************             JOBD(MBATCH) USER(*JOBD) RTGDTA(*JOBD) +                        /*CSC023*/
/************             INLLIBL(*JOBD)                                       /*CPK014*/ /*CSC023*/
             SBMJOB     JOB(FTC0630) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(FTC0630) +
                          PARM('''' '''' '''')') INLLIBL(*JOBD) OUTQ(*JOBD)               /*CSC023*/
             SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +
                          JOBD(MBATCH) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD) OUTQ(*JOBD)                                      /*CSC023*/
/*/COPY WNCPYSRC,FTC0105003                                          */
             ENDDO
             ENDDO
/**/
             ENDDO
/**/
 
/**   DATABASE ERROR HANDLING   **/
 
   IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
/**            RTVDTAARA  DTAARA(LDA (134 44))   RTNVAR(&MEM)        /*S01194*/
               RTVDTAARA  DTAARA(LDA (134 50))   RTNVAR(&MEM)        /*S01194*/
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
   ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*END:****ENDPGM***                                                   /*042167*/
END:                                                                  /*042167*/
/**/                                                                  /*042167*/
/* CALL AOC8000 to release locks */                                   /*042167*/
/**/                                                                  /*042167*/
             IF         COND(&PREF2 *EQ *BLANKS) THEN(DO)             /*042167*/
             CHGVAR     VAR(&MODULE) VALUE('FT')                      /*042167*/
             CHGVAR     VAR(&TRNREF) VALUE('               ')         /*042167*/
             CHGVAR     VAR(&RINFOR) VALUE('    ')                    /*042167*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                 /*042167*/
             CALL       PGM(AOC8000) PARM(&RTNCDE &MODULE &TRNREF +
                          &RINFOR)                                    /*042167*/
             ENDDO                                                    /*042167*/
/**/                                                                  /*042167*/
                                                                                          /*CRE020*/
          IF         COND((%SWITCH(XXXXXX00)) +
                     *AND (&CRE020 = 'Y')) THEN(DO)                                       /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL   REC000881 +
                          (FT0105 FT)') INLLIBL(*JOBD) MSGQ(MOPERQ)                       /*CRE020*/
                ENDDO                                                                     /*CRE020*/
                                                                                          /*CRE020*/
             ENDPGM                                                   /*042167*/
