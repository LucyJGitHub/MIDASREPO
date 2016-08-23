/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Fixed Account Charges Generation')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC5330 - FIXED ACCOUNT CHARGES GENERATION                  */
/*                                                                   */
/*   WARNING - THIS PROGRAM IS RUNNING IN TASK SPLIT MODE.           */                 /*CRE083BC*/
/*             DO NOT ADD ANY NEW PROGRAMS TO THIS CL IF IT IS NOT   */                 /*CRE083BC*/
/*             ABLE TO RUN  IN TASK SPLIT                            */                 /*CRE083BC*/
/*                                                                   */                 /*CRE083BC*/
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CRE083BC           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK009             Date 09Aug99              */
/*                      CCB003             Date 18Oct96              */
/*                      S01408             DATE 11MAY95              */
/*                      CPK002             DATE 17MAY95              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CRE083BC - COB Restructure - RE COB Optimisation Phase 1    */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CCB003 - COB Performance Enhancements - Task Split          */
/*                Call RE5330 to run as specified by DTAQ FACHGSERVE */
/*       S01408 - Addition of core hook REC5330MP1                   */
/*       CPK002 - Remove creation parameters which were using the    */
/*                adoption profile - USRPRF(*OWNER) -                */
/*                Use the standard CLP creation parameters instead.  */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/* */
             PGM        PARM(&CNAM &CSEQ)
                                                                      /*CCB003*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/************DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)             CCB003*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
/************DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)                CCB003*/
/************DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                    CCB003*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&CSEQC) TYPE(*CHAR) LEN(5)                /*CCB003*/
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(12)              /*CCB003*/
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10)            /*CCB003*/
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50) /*CCB003*/
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)             /*CCB003*/
             DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10)             /*CCB003*/
             DCL        VAR(&RCVDTAQ) TYPE(*CHAR) LEN(10)             /*CCB003*/
             DCL        VAR(&RCVWAIT) TYPE(*DEC) LEN(5 0) VALUE(600)  /*CCB003*/
             DCL        VAR(&RESTART) TYPE(*CHAR) LEN(1)              /*CCB003*/
                                                                      /*CCB003*/
             DCLF    FILE(TABTBRE)
                                                                      /*CCB003*/
/* Global monitor message */                                          /*CCB003*/
                                                                      /*CCB003*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*CCB003*/
/**/
/*    Check if 'Fixed A/C Charge' Ind. is on. */
/**/
             RCVF       RCDFMT(TABTBREF)
/**//********                                                           CCB003*/
/* *//*******                                                           CCB003*/
/************RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)                   CCB003*/
/* *//*******                                                           CCB003*/
/************CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))               CCB003*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')            CCB003*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC5330MP1                                          */
                                                                      /*S01408*/
/* */
/*  Setup and send pgm message                                      */
/* */
             IF         COND(&FACH *EQ 'Y') THEN(DO)
             SNDPGMMSG  MSG('REC5330 - Fixed account charges +
                          generation') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/* */
/* Create LDA if not present        */
/* */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
/* */
/*  Set off all switches                                            */
/* */
             CHGJOB SWS(00000000)
/* *//**********                                                        CCB003*/
/***Clear*extract files                                            */ /*CCB003*/
/* *//**********                                                        CCB003*/
/***************CLRPFM     FILE(GEFAPD)                                 CCB003*/
/***************CLRPFM     FILE(GEFAZZ)                                 CCB003*/
/* */
/*  Check for component restart                                     */
/* */
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
                                                                      /*CCB003*/
/* Check if any problems with COB components file */                  /*CCB003*/
                                                                      /*CCB003*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*CCB003*/
             GOTO       CMDLBL(ABNOR)                                 /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&RESTART) VALUE(&STAT)                    /*CCB003*/
/* */
/************IF*        COND(&STAT = 'Y') THEN(DO)                      CCB003*/
/* *//**********                                                        CCB003*/
/***And*copy*file                                                  */ /*CCB003*/
/* *//**********                                                        CCB003*/
/***************CPYF       FROMFILE(XTABTREXC) TOFILE(TABTREXC) +       CCB003*/
/***************            MBROPT(*REPLACE) FMTOPT(*NONE)              CCB003*/
/***************MONMSG     (CPF2817) CMPDTA(CPF2869) +                  CCB003*/
/***************            EXEC(CLRPFM TABTREXC)                       CCB003*/
/* *//**********                                                        CCB003*/
/***Change*data*area to 'OLD'                                      */ /*CCB003*/
/* *//**********                                                        CCB003*/
/************CHGVAR     VAR(&STAT) VALUE('N')                           CCB003*/
/************CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)             CCB003*/
/* *//**********                                                        CCB003*/
/************ENDDO                                                      CCB003*/
/* *//**********                                                        CCB003*/
/***Else*backup*file                                               */ /*CCB003*/
/* *//**********                                                        CCB003*/
/************ELSE       CMD(DO)                                         CCB003*/
/* *//**********                                                      /*CCB003*/
/**Delete*copy*file                                */                 /*CCB003*/
/* *//**********                                                        CCB003*/
/***************DLTF       FILE(XTABTREXC)                              CCB003*/
/***************   MONMSG MSGID(CPF2105)                                CCB003*/
/* *//**********                                                        CCB003*/
/***And*copy*file                                                  */ /*CCB003*/
/* *//**********                                                      /*CCB003*/
/***************CPYF       FROMFILE(TABTREXC) TOFILE(&TOLIB/XTABTREXC)/*CCB003*/
/***************        MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)  /*CCB003*/
/***************MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*CCB003*/
/***************           EXEC(CLRPFM XTABTREXC)                     /*CCB003*/
/* *//**********                                                        CCB003*/
/************ENDDO                                                      CCB003*/
/* */
/*  Change data area to 'NEW'                                       */
/* */
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
/* Set up call to QSNDDTAQ and override to new members */             /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&CSEQC) VALUE(&CSEQ)                      /*CCB003*/
             CHGVAR     VAR(&MEMBER) VALUE('FACHG' *CAT &CSEQC)       /*CCB003*/
             CHGVAR     VAR(&DTAQLIBL) VALUE('*LIBL')                 /*CCB003*/
             CHGVAR     VAR(&SNDDTAQ) VALUE('FACHGSERVE')             /*CCB003*/
             CHGVAR     VAR(&RCVDTAQ) VALUE(&MEMBER)                  /*CCB003*/
                                                                      /*CCB003*/
             OVRDBF     FILE(REFACGPD) TOFILE(REFACGPD) MBR(&MEMBER)  /*CCB003*/
             OVRDBF     FILE(REFACGPA) TOFILE(REFACGPA) MBR(&MEMBER)  /*CCB003*/
                                                                      /*CCB003*/
/* Start commitment control */                                        /*CCB003*/
/**********  STRCMTCTL  LCKLVL(*CHG)                           /*CCB003 CPK009*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                   /*CPK009*/
                                                                      /*CCB003*/
/* If restart, do not wait for the data queue entry */                /*CCB003*/
/* Clear any old data queue message from server but ensure that an */ /*CCB003*/
/* 'END' message, sent from the end proc job is not lost */           /*CCB003*/
                                                                      /*CCB003*/
             IF         COND(&RESTART = 'Y') THEN(DO)                 /*CCB003*/
             CHGVAR     VAR(&RCVWAIT) VALUE(5)                        /*CCB003*/
             CALL       PGM(QRCVDTAQ) PARM(&MEMBER &DTAQLIBL +
                          &MSGLENGTH &MSGDATA &RCVWAIT)               /*CCB003*/
             CHGVAR     VAR(&RCVWAIT) VALUE(600)                      /*CCB003*/
             CHGVAR     VAR(&MSGLENGTH) VALUE(50)                     /*CCB003*/
             IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)     /*CCB003*/
             CALL       PGM(QSNDDTAQ) PARM(&MEMBER &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)                        /*CCB003*/
             ENDDO                                                    /*CCB003*/
             GOTO       CMDLBL(RESTART)                               /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
/*  Request response from DTAQ whether to run job again or end */     /*CCB003*/
                                                                      /*CCB003*/
LOOP:                                                                 /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&MSGDATA) VALUE(&MEMBER)                  /*CCB003*/
             CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)                        /*CCB003*/
                                                                      /*CCB003*/
/* Wait on reply for 5 minutes */                                     /*CCB003*/
                                                                      /*CCB003*/
             CALL       PGM(QRCVDTAQ) PARM(&RCVDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA &RCVWAIT)               /*CCB003*/
                                                                      /*CCB003*/
/* If no reply, error message and terminate */                        /*CCB003*/
             IF         COND(&MSGLENGTH = 0) THEN(DO)                 /*CCB003*/
             SNDPGMMSG  MSG('No response from server for REC5330') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CCB003*/
             CHGJOB     SWS(XXXXXX11)                                 /*CCB003*/
             GOTO       CMDLBL(END)                                   /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
/* If reply = END, terminate */                                       /*CCB003*/
             IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)     /*CCB003*/
             GOTO       CMDLBL(END)                                   /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB002*/
/************CALL       PGM(RE5330)                                     CCB003*/
                                                                      /*CCB002*/
 RESTART:    CALL       PGM(RE5330) PARM(&RESTART)                    /*CCB003*/
                                                                      /*CCB002*/
/* */
/*  Database errors, if U7 + U8 ON  */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
/* */
                 SNDPGMMSG  MSGID(PEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ROLLBACK                                                 /*CCB003*/
             GOTO       CMDLBL(END)                                   /*CCB003*/
             ENDDO
                                                                      /*CCB003*/
             CHGVAR     VAR(&RESTART) VALUE('N')                      /*CCB003*/
                                                                      /*CCB003*/
             GOTO       CMDLBL(LOOP)                                  /*CCB003*/
                                                                      /*CCB003*/
ABNOR:       SNDPGMMSG  MSG('Program REC5330 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CCB003*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*CCB003*/
             CHGJOB     SWS(XXXXXX11)                                 /*CCB003*/
                                                                      /*CCB003*/
END:                                                                  /*CCB003*/
/* */
/*  If U7 and U8 OFF, change status to "N"                       */
/* */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/* */
             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
/* */
/***************DLTF       FILE(XTABTREXC)                              CCB003*/
/***************   MONMSG MSGID(CPF2105)                                CCB003*/
                                                                      /*CCB003*/
             ENDDO
                                                                      /*CCB003*/
/************ENDDO                                                      CCB003*/
/* */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
                                                                      /*CCB003*/
             ENDPGM
