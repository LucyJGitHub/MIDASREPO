/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas Drop out-of-date history processing')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC3663 - DROP OUT-OF-DATE HISTORY PROCESSING               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. AR1096378          Date 20Mar13              */
/*       Prev Amend No. CRE083AH           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      241159             Date 17Jul06              */
/*                      228542             Date 10Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      093571             Date 18Apr96              */
/*                      087455             Date 12May95              */
/*                      S01408             DATE 09MAY95              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR1096378 - NWDC issues encountered during link testing.    */
/*       CRE083AH - COB Restructure - RE COB Optimisation Phase 1    */
/*       241159 - Copy of history files in xxDPLIB are not deleted   */
/*                after successful run.Delete if DelCpyOfREHst = 'Y' */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       093571 - CPF message for empty file not monitored           */
/*       087455 - REHIO* files should be created in &DPLIB, else if  */
/*                Reopen I/C taken, restore of DMLIB will fail due   */
/*                to object differences.                             */
/*       S01408 - Addition of core hook REC3663MP1                   */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&RSEQ &RLEV &RENT)                      */                /*AR1096378*/
             PGM                                                                       /*AR1096378*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
/**/                                                                                    /*CRE083AH*/
             DCL        VAR(&SEVENT) TYPE(*CHAR) LEN(15)                                /*CRE083AH*/
             DCL        VAR(&SJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CRE083AH*/
             DCL        VAR(&FJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CRE083AH*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10) VALUE('REC3663')                 /*CRE083AH*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0) VALUE(10001)                     /*CRE083AH*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                  /*CRE083AH*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(25)                                 /*CRE083AH*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                   /*CRE083AH*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                   /*CRE083AH*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                    /*CRE083AH*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)                                /*CRE083AH*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)                               /*CRE083AH*/
/**/                                                                                    /*CRE083AH*/
/**/                                                                                      /*241159*/
/* Declare parameters to AOSVALR0     */                                                  /*241159*/
/**/                                                                                      /*241159*/
             DCL        VAR(&DLHSCP) TYPE(*CHAR) LEN(1)                                   /*241159*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE('       +
                          ')                                                              /*241159*/
             DCL        VAR(&POP01) TYPE(*CHAR) LEN(20) +
                          VALUE('DelCpyOfREHst')                                          /*241159*/
             DCL        VAR(&POP02) TYPE(*CHAR) LEN(20)                                   /*241159*/
             DCL        VAR(&POP03) TYPE(*CHAR) LEN(20)                                   /*241159*/
             DCL        VAR(&POP04) TYPE(*CHAR) LEN(20)                                   /*241159*/
             DCL        VAR(&POP05) TYPE(*CHAR) LEN(20)                                   /*241159*/
             DCL        VAR(&POP06) TYPE(*CHAR) LEN(20)                                   /*241159*/
             DCL        VAR(&POP07) TYPE(*CHAR) LEN(20)                                   /*241159*/
             DCL        VAR(&POP08) TYPE(*CHAR) LEN(20)                                   /*241159*/
             DCL        VAR(&POP09) TYPE(*CHAR) LEN(20)                                   /*241159*/
             DCL        VAR(&POP10) TYPE(*CHAR) LEN(20)                                   /*241159*/
             DCL        VAR(&PVL01) TYPE(*CHAR) LEN(200)                                  /*241159*/
             DCL        VAR(&PVL02) TYPE(*CHAR) LEN(200)                                  /*241159*/
             DCL        VAR(&PVL03) TYPE(*CHAR) LEN(200)                                  /*241159*/
             DCL        VAR(&PVL04) TYPE(*CHAR) LEN(200)                                  /*241159*/
             DCL        VAR(&PVL05) TYPE(*CHAR) LEN(200)                                  /*241159*/
             DCL        VAR(&PVL06) TYPE(*CHAR) LEN(200)                                  /*241159*/
             DCL        VAR(&PVL07) TYPE(*CHAR) LEN(200)                                  /*241159*/
             DCL        VAR(&PVL08) TYPE(*CHAR) LEN(200)                                  /*241159*/
             DCL        VAR(&PVL09) TYPE(*CHAR) LEN(200)                                  /*241159*/
             DCL        VAR(&PVL10) TYPE(*CHAR) LEN(200)                                  /*241159*/
/*/COPY WNCPYSRC,REC3663009                                          */
/**/
             SNDPGMMSG  MSG('REC3663 - Drop out-of-date history +
                          processing') TOMSGQ(MRUNQ)
/**/
             RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)
/**/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB')
             CHGVAR     VAR(&DLIB) VALUE(&PRE *TCAT 'DPLIB')
             CHGVAR     VAR(&JLIB) VALUE(&PRE *TCAT 'JLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC3663MP1                                          */
                                                                      /*S01408*/
/**/
/**/
/**/                                                                                      /*241159*/
/* Check if the current setting of 'Delete Retail History Copy files' is 'Y' */           /*241159*/
/**/                                                                                      /*241159*/
             CALL       PGM(AOSVALR0) PARM(&PRTCD &POP01 &PVL01 +
                          &POP02 &PVL02 &POP03 &PVL03 &POP04 &PVL04 +
                          &POP05 &PVL05 &POP06 &PVL06 &POP07 &PVL07 +
                          &POP08 &PVL08 &POP09 &PVL09 &POP10 &PVL10)                      /*241159*/
             IF         COND(&PRTCD *EQ '       ') THEN(DO)                               /*241159*/
               CHGVAR     VAR(&DLHSCP) VALUE(%SUBSTRING(&PVL01 1 1))                      /*241159*/
             ENDDO                                                                        /*241159*/
             ELSE       CMD(DO)                                                           /*241159*/
               SNDPGMMSG  MSG('Database Error in File SDSVALPD, Key +
                          DelCpyOfREHst') TOMSGQ(MRUNQ)                                   /*241159*/
               GOTO       CMDLBL(ENDPGM)                                                  /*241159*/
             ENDDO                                                                        /*241159*/
                                                                                          /*241159*/
/**********  DLTF       FILE(XREHISPD) */                                               /*CRE083AH*/
/**********  MONMSG     MSGID(CPF0000) */                                               /*CRE083AH*/
/**********  DLTF       FILE(XREHISPM) */                                               /*CRE083AH*/
/**********  MONMSG     MSGID(CPF0000) */                                               /*CRE083AH*/
/**********  DLTF       FILE(XREHISPS) */                                               /*CRE083AH*/
/**********  MONMSG     MSGID(CPF0000) */                                               /*CRE083AH*/
/**********  DLTF       FILE(XREHPOSPP) */                                              /*CRE083AH*/
/**********  MONMSG     MSGID(CPF0000) */                                               /*CRE083AH*/
/**********  DLTF       FILE(XREHPOSPM) */                                              /*CRE083AH*/
/**********  MONMSG     MSGID(CPF0000) */                                               /*CRE083AH*/
/**********  DLTF       FILE(XREHPOSR1) */                                              /*CRE083AH*/
/**********  MONMSG     MSGID(CPF0000) */                                               /*CRE083AH*/
/**********  DLTF       FILE(XREHPOSR2) */                                              /*CRE083AH*/
/**********  MONMSG     MSGID(CPF0000) */                                               /*CRE083AH*/
/**********  DLTF       FILE(XREHPOSR3) */                                              /*CRE083AH*/
/**********  MONMSG     MSGID(CPF0000) */                                               /*CRE083AH*/
/**/                                                                                    /*CRE083AH*/
/* Write current journal sequence number to file SCJSEQPD */                            /*CRE083AH*/
/**/                                                                                    /*CRE083AH*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                        /*CRE083AH*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *TCAT &CNAM +
                        *TCAT &CSEQA)                                                   /*CRE083AH*/
             CHGVAR     VAR(&SEVENT) VALUE(&CNAM *TCAT &CSEQA)                          /*CRE083AH*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                        FLAG('S') TEXT(&STEXT)                                          /*CRE083AH*/
/**/
STEP1:
/**********  CRTDUPOBJ  OBJ(REHISPD) FROMLIB(&DMLIB) OBJTYPE(*FILE) + */                /*CRE083AH*/
/**********               TOLIB(&DLIB) NEWOBJ(XREHISPD) DATA(*YES) */                   /*CRE083AH*/
/**********  MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 CPF2116 + */              /*CRE083AH*/
/**********               CPF2122 CPF2151 CPF2162 CPF2176 CPF2182) + */                 /*CRE083AH*/
/**********               EXEC(DO) */                                                   /*CRE083AH*/
/**********  SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : REHISPD by + */               /*CRE083AH*/
/**********               PGM : REC3663 (STEP1)') TOMSGQ(MRUNQ) */                      /*CRE083AH*/
/**********  GOTO       CMDLBL(ENDPGM) */                                               /*CRE083AH*/
/**********  ENDDO */                                                                   /*CRE083AH*/
/*/COPY WNCPYSRC,REC3663001                                          */
STEP2:
/**********  CRTDUPOBJ  OBJ(REHISPS) FROMLIB(&DMLIB) OBJTYPE(*FILE) + */                /*CRE083AH*/
/**********               TOLIB(&DLIB) NEWOBJ(XREHISPS) DATA(*YES) */                   /*CRE083AH*/
/**********  MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 CPF2116 + */              /*CRE083AH*/
/**********               CPF2122 CPF2151 CPF2162 CPF2176 CPF2182) + */                 /*CRE083AH*/
/**********               EXEC(DO) */                                                   /*CRE083AH*/
/**********  SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : REHISPS by + */               /*CRE083AH*/
/**********               PGM : REC3663 (STEP2)') TOMSGQ(MRUNQ) */                      /*CRE083AH*/
/**********  GOTO       CMDLBL(ENDPGM) */                                               /*CRE083AH*/
/**********  ENDDO */                                                                   /*CRE083AH*/
/*/COPY WNCPYSRC,REC3663002                                          */
STEP3:
/**********  CRTDUPOBJ  OBJ(REHPOSPP) FROMLIB(&DMLIB) OBJTYPE(*FILE) + */               /*CRE083AH*/
/**********               TOLIB(&DLIB) NEWOBJ(XREHPOSPP) DATA(*YES) */                  /*CRE083AH*/
/**********  MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 CPF2116 + */              /*CRE083AH*/
/**********               CPF2122 CPF2151 CPF2162 CPF2176 CPF2182) + */                 /*CRE083AH*/
/**********               EXEC(DO) */                                                   /*CRE083AH*/
/**********  SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : REHPOSPP by + */              /*CRE083AH*/
/**********               PGM : REC3663 (STEP3)') TOMSGQ(MRUNQ) */                      /*CRE083AH*/
/**********  GOTO       CMDLBL(ENDPGM) */                                               /*CRE083AH*/
/**********  ENDDO */                                                                   /*CRE083AH*/
STEP4:
/**********  CRTDUPOBJ  OBJ(REHPOSPM) FROMLIB(&DMLIB) OBJTYPE(*FILE) + */               /*CRE083AH*/
/**********               TOLIB(&DLIB) NEWOBJ(XREHPOSPM) DATA(*YES) */                  /*CRE083AH*/
/**********  MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 CPF2116 + */              /*CRE083AH*/
/**********               CPF2122 CPF2151 CPF2162 CPF2176 CPF2182) + */                 /*CRE083AH*/
/**********               EXEC(DO) */                                                   /*CRE083AH*/
/**********  SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : REHPOSPM by + */              /*CRE083AH*/
/**********               PGM : REC3663 (STEP4)') TOMSGQ(MRUNQ) */                      /*CRE083AH*/
/**********  GOTO       CMDLBL(ENDPGM) */                                               /*CRE083AH*/
/**********  ENDDO */                                                                   /*CRE083AH*/
STEP5:
/**********  CRTDUPOBJ  OBJ(REHPOSR1) FROMLIB(&DMLIB) OBJTYPE(*FILE) + */               /*CRE083AH*/
/**********               TOLIB(&DLIB) NEWOBJ(XREHPOSR1) DATA(*YES) */                  /*CRE083AH*/
/**********  MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 CPF2116 + */              /*CRE083AH*/
/**********               CPF2122 CPF2151 CPF2162 CPF2176 CPF2182) + */                 /*CRE083AH*/
/**********               EXEC(DO) */                                                   /*CRE083AH*/
/**********  SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : REHPOSR1 by + */              /*CRE083AH*/
/**********               PGM : REC3663 (STEP5)') TOMSGQ(MRUNQ) */                      /*CRE083AH*/
/**********  GOTO       CMDLBL(ENDPGM) */                                               /*CRE083AH*/
/**********  ENDDO */                                                                   /*CRE083AH*/
STEP6:
/**********  CRTDUPOBJ  OBJ(REHPOSR2) FROMLIB(&DMLIB) OBJTYPE(*FILE) + */               /*CRE083AH*/
/**********               TOLIB(&DLIB) NEWOBJ(XREHPOSR2) DATA(*YES) */                  /*CRE083AH*/
/**********  MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 CPF2116 + */              /*CRE083AH*/
/**********               CPF2122 CPF2151 CPF2162 CPF2176 CPF2182) + */                 /*CRE083AH*/
/**********               EXEC(DO) */                                                   /*CRE083AH*/
/**********  SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : REHPOSR2 by + */              /*CRE083AH*/
/**********               PGM : REC3663 (STEP6)') TOMSGQ(MRUNQ) */                      /*CRE083AH*/
/**********  GOTO       CMDLBL(ENDPGM) */                                               /*CRE083AH*/
/**********  ENDDO */                                                                   /*CRE083AH*/
STEP7:
/**********  CRTDUPOBJ  OBJ(REHPOSR3) FROMLIB(&DMLIB) OBJTYPE(*FILE) + */               /*CRE083AH*/
/**********               TOLIB(&DLIB) NEWOBJ(XREHPOSR3) DATA(*YES) */                  /*CRE083AH*/
/**********  MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 CPF2116 + */              /*CRE083AH*/
/**********               CPF2122 CPF2151 CPF2162 CPF2176 CPF2182) + */                 /*CRE083AH*/
/**********               EXEC(DO) */                                                   /*CRE083AH*/
/**********  SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : REHPOSR3 by + */              /*CRE083AH*/
/**********               PGM : REC3663 (STEP7)') TOMSGQ(MRUNQ) */                      /*CRE083AH*/
/**********  GOTO       CMDLBL(ENDPGM) */                                               /*CRE083AH*/
/**********  ENDDO */                                                                   /*CRE083AH*/
STEP8:
/**********  CRTDUPOBJ  OBJ(REHISPM) FROMLIB(&DMLIB) OBJTYPE(*FILE) + */                /*CRE083AH*/
/**********               TOLIB(&DLIB) NEWOBJ(XREHISPM) DATA(*YES) */                   /*CRE083AH*/
/**********  MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 CPF2116 + */              /*CRE083AH*/
/**********               CPF2122 CPF2151 CPF2162 CPF2176 CPF2182) + */                 /*CRE083AH*/
/**********               EXEC(DO) */                                                   /*CRE083AH*/
/**********  SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : REHISPM by + */               /*CRE083AH*/
/**********               PGM : REC3663 (STEP8)') TOMSGQ(MRUNQ) */                      /*CRE083AH*/
/**********  GOTO       CMDLBL(ENDPGM) */                                               /*CRE083AH*/
/**********  ENDDO */                                                                   /*CRE083AH*/
             CHGJOB     SWS(XXXXXX00)
/**/
             DLTF       FILE(REHIOPD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(REHIOPS)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(REHIOPM)
             MONMSG     MSGID(CPF0000)
/*/COPY WNCPYSRC,REC3663005                                          */
/**/
STEP13:
/*********** CRTDUPOBJ  OBJ(REHISPD) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
/***********              NEWOBJ(REHIOPD) DATA(*NO)                    *087455*/
             CRTDUPOBJ  OBJ(REHISPD) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&DLIB) NEWOBJ(REHIOPD) DATA(*NO)      /*087455*/
             MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 CPF2116 +
                          CPF2122 CPF2151 CPF2162 CPF2176 CPF2182) +
                          EXEC(DO)
             SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : REHIOPD by +
                          PGM : REC3663 (STEP13)') TOMSGQ(MRUNQ)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
/*/COPY WNCPYSRC,REC3663003                                          */
STEP14:
/*********** CRTDUPOBJ  OBJ(REHISPS) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
/***********              NEWOBJ(REHIOPS) DATA(*NO)                    *087455*/
             CRTDUPOBJ  OBJ(REHISPS) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&DLIB) NEWOBJ(REHIOPS) DATA(*NO)      /*087455*/
             MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 CPF2116 +
                          CPF2122 CPF2151 CPF2162 CPF2176 CPF2182) +
                          EXEC(DO)
             SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : REHIOPS by +
                          PGM : REC3663 (STEP14)') TOMSGQ(MRUNQ)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
/*/COPY WNCPYSRC,REC3663004                                          */
STEP15:
/*********** CRTDUPOBJ  OBJ(REHISPM) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
/***********              NEWOBJ(REHIOPM) DATA(*NO)                    *087455*/
             CRTDUPOBJ  OBJ(REHISPM) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&DLIB) NEWOBJ(REHIOPM) DATA(*NO)      /*087455*/
             MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 CPF2116 +
                          CPF2122 CPF2151 CPF2162 CPF2176 CPF2182) +
                          EXEC(DO)
             SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : REHIOPM by +
                          PGM : REC3663 (STEP15)') TOMSGQ(MRUNQ)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
             CALL PGM(RE3663)
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             CLRPFM FILE(REHISPD)
             CLRPFM FILE(REHISPS)
             CLRPFM FILE(REHISPM)
/*/COPY WNCPYSRC,REC3663006                                          */
/**/
             CPYF       FROMFILE(REHIOPD) TOFILE(REHISPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(DO)
             SNDPGMMSG  MSG('File REHIOPD not found. +
                          PGM : REC3663') TOMSGQ(MRUNQ)
             GOTO       CMDLBL(EXIT7)
             ENDDO
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/**/
             CPYF       FROMFILE(REHIOPS) TOFILE(REHISPS) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(DO)
             SNDPGMMSG  MSG('File REHIOPS not found. +
                          PGM : REC3663') TOMSGQ(MRUNQ)
             GOTO       CMDLBL(EXIT7)
             ENDDO
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/**/
             CPYF       FROMFILE(REHIOPM) TOFILE(REHISPM) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(DO)
             SNDPGMMSG  MSG('File REHIOPS not found. +
                          PGM : REC3663') TOMSGQ(MRUNQ)
             GOTO       CMDLBL(EXIT7)
             ENDDO
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*/COPY WNCPYSRC,REC3663007                                          */
/**/
/**********  RGZPFM     FILE(REHPOSPP)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF0000)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('REHPOSPP' '*FIRST')                          /*228542*/
/**********  RGZPFM     FILE(REHPOSPM)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF0000)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('REHPOSPM' '*FIRST')                          /*228542*/
/**********  RGZPFM     FILE(REHPOSR1)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF0000)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('REHPOSR1' '*FIRST')                          /*228542*/
/**********  RGZPFM     FILE(REHPOSR2)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF0000)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('REHPOSR2' '*FIRST')                          /*228542*/
/**********  RGZPFM     FILE(REHPOSR3)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF0000)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('REHPOSR3' '*FIRST')                          /*228542*/
/**/                                                                                      /*241159*/
/* DELETE XRE* FILES IN XXDPLIB NOW */                                                    /*241159*/
/* If system value DelCpyOfREHst = 'Y' */                                                 /*241159*/
/**/                                                                                      /*241159*/
             IF         COND(&DLHSCP *EQ 'Y') THEN(DO)                                    /*241159*/
             DLTF       FILE(XREHISPD)                                                    /*241159*/
             MONMSG     MSGID(CPF0000)                                                    /*241159*/
             DLTF       FILE(XREHISPM)                                                    /*241159*/
             MONMSG     MSGID(CPF0000)                                                    /*241159*/
             DLTF       FILE(XREHISPS)                                                    /*241159*/
             MONMSG     MSGID(CPF0000)                                                    /*241159*/
             DLTF       FILE(XREHPOSPP)                                                   /*241159*/
             MONMSG     MSGID(CPF0000)                                                    /*241159*/
             DLTF       FILE(XREHPOSPM)                                                   /*241159*/
             MONMSG     MSGID(CPF0000)                                                    /*241159*/
             DLTF       FILE(XREHPOSR1)                                                   /*241159*/
             MONMSG     MSGID(CPF0000)                                                    /*241159*/
             DLTF       FILE(XREHPOSR2)                                                   /*241159*/
             MONMSG     MSGID(CPF0000)                                                    /*241159*/
             DLTF       FILE(XREHPOSR3)                                                   /*241159*/
             MONMSG     MSGID(CPF0000)                                                    /*241159*/
             CLRPFM     FILE(REHIOPD)                                                     /*241159*/
             CLRPFM     FILE(REHIOPM)                                                     /*241159*/
             CLRPFM     FILE(REHIOPS)                                                     /*241159*/
             ENDDO                                                                        /*241159*/
/**/
             GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
/**/
                 RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
                 CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                 SNDPGMMSG  MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)
                 GOTO       CMDLBL(EXIT7)
             ENDDO
/**/
EXIT7:
/**********  CPYF       FROMFILE(XREHPOSR3) TOFILE(REHPOSR3) + */                       /*CRE083AH*/
/**********               MBROPT(*REPLACE) FMTOPT(*MAP *DROP) */                        /*CRE083AH*/
/**/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM + */                 /*CRE083AH*/
/**********               FILE(REHPOSR3)) */                                     /*093571 CRE083AH*/
/**********  MONMSG     MSGID(CPF0000) EXEC(DO) */                                      /*CRE083AH*/
/**********  SNDPGMMSG  MSG('Error in RESTART COPY with XREHPOSR3 in + */               /*CRE083AH*/
/**********               REC3663 (EXIT7)') TOMSGQ(MRUNQ) */                            /*CRE083AH*/
/**********  ENDDO */                                                                   /*CRE083AH*/
/**/
EXIT6:
/**********  CPYF       FROMFILE(XREHPOSR2) TOFILE(REHPOSR2) + */                       /*CRE083AH*/
/**********               MBROPT(*REPLACE) FMTOPT(*MAP *DROP) */                        /*CRE083AH*/
/**/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM + */                 /*CRE083AH*/
/**********               FILE(REHPOSR2)) */                                     /*093571 CRE083AH*/
/**********  MONMSG     MSGID(CPF0000) EXEC(DO) */                                      /*CRE083AH*/
/**********  SNDPGMMSG  MSG('Error in RESTART COPY with XREHPOSR2 in + */               /*CRE083AH*/
/**********               REC3663 (EXIT6)') TOMSGQ(MRUNQ) */                            /*CRE083AH*/
/**********  ENDDO */                                                                   /*CRE083AH*/
/**/
EXIT5:
/**********  CPYF       FROMFILE(XREHPOSR1) TOFILE(REHPOSR1) + */                       /*CRE083AH*/
/**********               MBROPT(*REPLACE) FMTOPT(*MAP *DROP) */                        /*CRE083AH*/
/**/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM + */                 /*CRE083AH*/
/**********               FILE(REHPOSR1)) */                                     /*093571 CRE083AH*/
/**********  MONMSG     MSGID(CPF0000) EXEC(DO) */                                      /*CRE083AH*/
/**********  SNDPGMMSG  MSG('Error in RESTART COPY with XREHPOSR1 in + */               /*CRE083AH*/
/**********               REC3663 (EXIT5)') TOMSGQ(MRUNQ) */                            /*CRE083AH*/
/**********  ENDDO */                                                                   /*CRE083AH*/
/**/
EXIT4:
/**********  CPYF       FROMFILE(XREHPOSPM) TOFILE(REHPOSPM) +  */                      /*CRE083AH*/
/**********               MBROPT(*REPLACE) FMTOPT(*MAP *DROP) */                        /*CRE083AH*/
/**/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM + */                 /*CRE083AH*/
/**********               FILE(REHPOSPM)) */                                     /*093571 CRE083AH*/
/**********  MONMSG     MSGID(CPF0000) EXEC(DO) */                                      /*CRE083AH*/
/**********  SNDPGMMSG  MSG('Error in RESTART COPY with XREHPOSPM in + */               /*CRE083AH*/
/**********               REC3663 (EXIT4)') TOMSGQ(MRUNQ) */                            /*CRE083AH*/
/**********  ENDDO */                                                                   /*CRE083AH*/
/**/
EXIT3:
/**********  CPYF       FROMFILE(XREHPOSPP) TOFILE(REHPOSPP) + */                       /*CRE083AH*/
/**********               MBROPT(*REPLACE) FMTOPT(*MAP *DROP) */                        /*CRE083AH*/
/**/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM + */                 /*CRE083AH*/
/**********               FILE(REHPOSPP)) */                                     /*093571 CRE083AH*/
/**********  MONMSG     MSGID(CPF0000) EXEC(DO) */                                      /*CRE083AH*/
/**********  SNDPGMMSG  MSG('Error in RESTART COPY with XREHPOSPP in + */               /*CRE083AH*/
/**********               REC3663 (EXIT3)') TOMSGQ(MRUNQ) */                            /*CRE083AH*/
/**********  ENDDO */                                                                   /*CRE083AH*/
/**/
EXIT2:
/**********  CPYF       FROMFILE(XREHISPS) TOFILE(REHISPS) + */                         /*CRE083AH*/
/**********               MBROPT(*REPLACE) FMTOPT(*MAP *DROP) */                        /*CRE083AH*/
/**/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +                    /*CRE083AH*/
/**********               FILE(REHISPS))                                         /*093571 CRE083AH*/
/**********  MONMSG     MSGID(CPF0000) EXEC(DO) */                                      /*CRE083AH*/
/**********  SNDPGMMSG  MSG('Error in RESTART COPY with XREHISPS in + */                /*CRE083AH*/
/**********               REC3663 (EXIT2)') TOMSGQ(MRUNQ) */                            /*CRE083AH*/
/**********  ENDDO */                                                                   /*CRE083AH*/
/**/
EXIT1:
/**********  CPYF       FROMFILE(XREHISPD) TOFILE(REHISPD) + */                         /*CRE083AH*/
/**********               MBROPT(*REPLACE) FMTOPT(*MAP *DROP) */                        /*CRE083AH*/
/**/                                                                                    /*CRE083AH*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM + */                 /*CRE083AH*/
/**********               FILE(REHISPD)) */                                      /*093571 CRE083AH*/
/**********  MONMSG     MSGID(CPF0000) EXEC(DO) */                                      /*CRE083AH*/
/**********  SNDPGMMSG  MSG('Error in RESTART COPY with XREHISPD in + */                /*CRE083AH*/
/**********               REC3663 (EXIT1)') TOMSGQ(MRUNQ) */                            /*CRE083AH*/
/**********  ENDDO */                                                                   /*CRE083AH*/
/**/
EXIT0:
/**********  CPYF       FROMFILE(XREHISPM) TOFILE(REHISPM) + */                         /*CRE083AH*/
/**********               MBROPT(*REPLACE) FMTOPT(*MAP *DROP) */                        /*CRE083AH*/
/**/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM + */                 /*CRE083AH*/
/**********               FILE(REHISPM)) */                                      /*093571 CRE083AH*/
/**********  MONMSG     MSGID(CPF0000) EXEC(DO) */                                      /*CRE083AH*/
/**********  SNDPGMMSG  MSG('Error in RESTART COPY with XREHISPM in + */                /*CRE083AH*/
/**********               REC3663 (EXIT0)') TOMSGQ(MRUNQ) */                            /*CRE083AH*/
/**********  ENDDO */                                                                   /*CRE083AH*/
/*/COPY WNCPYSRC,REC3663008                                          */
/**/
/**/                                                                                    /*CRE083AH*/
/* Begin recovery from error. */                                                        /*CRE083AH*/
/**/                                                                                    /*CRE083AH*/
                   RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                            /*CRE083AH*/
                   RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) +
                              FROMENT(*LAST) TOENT(*FIRST) +
                              SEARCH(*DESCEND) JOB(&NBR/&USR/&JOB) +
                              RTNSEQNBR(&START) RTNRCV(&SJRNRCVR)                       /*CRE083AH*/
                   MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                           /*CRE083AH*/
                   CHGVAR     VAR(&START) VALUE(0)                                      /*CRE083AH*/
                   ENDDO                                                                /*CRE083AH*/
/**/                                                                                    /*CRE083AH*/
/* Determine starting journal sequence */                                               /*CRE083AH*/
/* number of current job. */                                                            /*CRE083AH*/
/**/                                                                                    /*CRE083AH*/
                   SCRTVJEVT  EVENT(&SEVENT) FLAG('S') +
                              RECEIVER(&FJRNRCVR) SEQ(&FINISH)                          /*CRE083AH*/
/**/                                                                                    /*CRE083AH*/
/* Remove journal changes. */                                                           /*CRE083AH*/
/**/                                                                                    /*CRE083AH*/
                   IF         COND((&START *NE 0) *AND +
                              (&FINISH *NE 0)) THEN(DO)                                 /*CRE083AH*/
                      RMVJRNCHG    JRN(ICJRN) FILE((REHISPD) +
                                   (REHISPS) (REHISPM) (REHPOSPP) +
                                   (REHPOSPM) (REHPOSR1) +
                                   (REHPOSR2) (REHPOSR3) +
                                   (REHIOPD) (REHIOPS) (REHIOPM)) +
                                   FROMENT(&START) TOENT(&FINISH) +
                                   RCVRNG(&SJRNRCVR &FJRNRCVR)                          /*CRE083AH*/
                      MONMSG       MSGID(CPF7049 CPF7042 CPF9801 +
                                   CPF7041)                                             /*CRE083AH*/
                   ENDDO                                                                /*CRE083AH*/
ENDPGM:                                                                                 /*CRE083AH*/
/**/                                                                                    /*CRE083AH*/
/* Write current journal sequence number to file SCJSEQPD */                            /*CRE083AH*/
/**/                                                                                    /*CRE083AH*/
                  CHGVAR     VAR(&STEXT) VALUE(' ')                                     /*CRE083AH*/
                  CHGVAR     VAR(&STEXT) VALUE('End of ' *TCAT &CNAM +
                             *TCAT &CSEQA)                                              /*CRE083AH*/
                  SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                             FLAG('E') TEXT(&STEXT)                                     /*CRE083AH*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                                     /*CRE083AH*/
/***ENDPGM:      ENDPGM */                                                              /*CRE083AH*/
