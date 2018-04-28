/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GO On-Line Synch. of Global Layer MESSAGE')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0102 - On-Line Synchronisation of Global Layer MESSAGE   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/*       Last Amend No. MD021155           Date 09Jul13              */
/*       Prev Amend No. CCB023             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BG18886            Date 02Jun08              */
/*                      BUG14041           Date 31May07              */
/*                      BUG12215           Date 27Oct06              */
/*                      BUG12185           Date 09Oct06              */
/*                      CRE026             Date 24May06              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG12461           Date 11Nov06              */
/*                      CSD031             Date 10Apr06              */
/*                      BUG9619            Date 01Feb06              */
/*                      CGP001  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD021155 - COB Restructure Phase 1 remnants                 */
/*                - Incorrect annotation                             */
/*       CCB023 - COB Restructure - Input Cycle Termination          */
/*                Restructuring                                      */
/*       BG18886 - Amend non-standard codes.                         */
/*       BUG14041 - GOC0102 Component Failed                         */
/*       BUG12215 - Improve switchability of Consumer Banking codes  */
/*       BUG12185 - Change file in INZPFM operation (Recompile)      */
/*       CRE026 - Consumer Banking                                   */
/*       BUG12461 - SCKOBJLCB 00001 failed during CoB run            */
/*       CSD031 - Enhanced Centralised Static Data                   */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       CGP001 - Global Processing                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&INST)
 
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*CSD031*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)                                    /*CSD031*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)                                    /*CSD031*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)                                  /*CSD031*/
             DCL        VAR(&INST)   TYPE(*CHAR) LEN(5)
             DCL        VAR(&MSG)    TYPE(*CHAR) LEN(20)
/* Parameters For QCLRDTAQ */                                                             /*CRE026*/
/**********  DCL        VAR(&NAME) TYPE(*CHAR) LEN(10) +
                             VALUE('SDCBTRDTQ')                    */              /*CRE026 CCB023*/
/**********  DCL        VAR(&LIB) TYPE(*CHAR) LEN(10) VALUE('*LIBL')*/             /*CRE026 CCB023*/
/**********  DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(10)*/            /*CRE026 CCB023*/
/**********  DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(10) VALUE('END')*/           /*CRE026 CCB023*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
/**********  DCL        VAR(&JRNA)   TYPE(*CHAR) LEN(6)            */              /*CRE026 CCB023*/
/**********  DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')  */              /*CRE026 CCB023*/
/**********  DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)               */            /*BUG14041 CCB023*/
/**********  DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)              */            /*BUG14041 CCB023*/
/**********  DCL        VAR(&USER) TYPE(*CHAR) LEN(10)             */            /*BUG14041 CCB023*/
/**********  DCL        VAR(&LOOP) TYPE(*CHAR) LEN(1) VALUE('N')   */            /*BUG14041 CCB023*/
/**********  DCLF       FILE(SCOBJLEQPD)                           */            /*BUG14041 CCB023*/
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Check if CSD031 is on. */                                                            /*BUG12461*/
                                                                                        /*BUG12461*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                    /*BUG12461*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                    /*BUG12461*/
             CHGVAR     VAR(&PSARD) VALUE('CSD031')                                     /*BUG12461*/
                                                                                        /*BUG12461*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &DSFDY)                 /*BUG12461*/
                                                                                        /*BUG12461*/
/* Try to end the acceptance job if CSD031 is on. */                                    /*BUG12461*/
                                                                                        /*BUG12461*/
             IF         COND(&PRTCD *EQ '       ') THEN(CALL +
                          PGM(SDC000060E))                                              /*BUG12461*/
             ELSE       CMD(IF COND(&PRTCD *NE '*NRF   ') THEN(GOTO +
                          CMDLBL(ABNOR)))                                               /*BUG12461*/
                                                                                        /*BUG12461*/
/* instruction must be END */
 
/**********  IF         COND(&INST *= 'END') THEN(DO)                                 */ /*BG18886*/
             IF         COND(&INST *NE 'END') THEN(DO)                                   /*BG18886*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CHGVAR     VAR(&MSG) VALUE(&INST *CAT '|')
                                                                                          /*CRE026*/
/**Check*for*switchable*feature*CRE026*-*Consumer*Banking**/                     /*BUG12215 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&PRTCD '*VERIFY' +
                        'CRE026')                                  */            /*BUG12215 CCB023*/
/**********  IF         COND(&PRTCD *EQ ' ') THEN(DO)              */            /*BUG12215 CCB023*/
/**********  RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)            */            /*BUG14041 CCB023*/
/**********  WRKOBJLCK  OBJ(GOEOSJSPD) OBJTYPE(*FILE) MBR(*ALL) +
                          OUTPUT(*PRINT)                           */            /*BUG14041 CCB023*/
/**********  CPYSPLF    FILE(QPDSPOLK) TOFILE(SCOBJLEQPD) +
                          JOB(&NBR/&USER/&JOB) SPLNBR(*LAST)       */            /*BUG14041 CCB023*/
                                                                                        /*BUG14041*/
/***LOOP:**                                                                 */ /*BUG14041 MD021155*/
/**********  RCVF                                                  */            /*BUG14041 CCB023*/
                                                                                        /*BUG14041*/
/**********  MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&LOOP) +
                          VALUE('Y'))                              */            /*BUG14041 CCB023*/
/**********  IF         COND(&OBJLCK *EQ 'GOEOSJSPD') THEN(DO)     */            /*BUG14041 CCB023*/
/**********  ENDJOB     JOB(&JOBNBR/&JOBUSR/&JOBNAM) OPTION(*IMMED)*/            /*BUG14041 CCB023*/
/**********  DLYJOB     DLY(30)                                    */            /*BUG14041 CCB023*/
/**********  ENDDO                                                 */            /*BUG14041 CCB023*/
/**********  IF         COND(&LOOP *EQ 'N') THEN(DO)               */                     /*CCB023*/
/**********  GOTO       CMDLBL(LOOP)                               */            /*BUG14041 CCB023*/
/**********  ENDDO                                                 */                     /*CCB023*/
 
/**********  ALCOBJ     OBJ((GOEOSJSPD *FILE *EXCL)) WAIT(0)       */              /*CRE026 CCB023*/
/**********  MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)    */              /*CRE026 CCB023*/
/**CHECK*FOR*SWITCHABLE*FEATURE*CRE026*-*CONSUMER BANKING*/                  /*CRE026*/ /*BUG12215*/
                                                                                          /*CRE026*/
/**********  CALL       PGM(AOSARDR0) PARM(&PRTCD '*VERIFY' +
                        'CRE026')                                **********/ /*CRE026*/ /*BUG12215*/
/**********  IF         COND(&PRTCD *EQ ' ') THEN(DO)            **********/ /*CRE026*/ /*BUG12215*/
     /**Get*the*name*of*journal**/                                                 /*CRE026 CCB023*/
/**********  RTVDTAARA  DTAARA(KAPJRN (24 6)) RTNVAR(&JRNA)        */              /*CRE026 CCB023*/
/**********  SNDJRNE    JRN(&JRNA) TYPE('OS') ENTDTA(&MSG)         */              /*CRE026 CCB023*/
/**********  GOTO       CMDLBL(NEXT1)                              */              /*CRE026 CCB023*/
/**********  ENDDO                                                 */              /*CRE026 CCB023*/
/**********  ENDDO                                               **********/ /*CRE026*/ /*BUG12215*/
                                                                                          /*CRE026*/
/**********  DLCOBJ     OBJ((GOEOSJSPD *FILE *EXCL))               */              /*CRE026 CCB023*/
/**********  MONMSG     MSGID(CPF0000 MCH0000 RPG0000)             */              /*CRE026 CCB023*/
                                                                                          /*CRE026*/
/***NEXT1:*                                                                   */ /*CRE026 MD021155*/
/**********  ALCOBJ     OBJ((GLNOSTPD *FILE *EXCL)) WAIT(0)        */              /*CRE026 CCB023*/
/**********  MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)    */              /*CRE026 CCB023*/
/**********  CHGDTAARA  DTAARA(GLNOSTCTL (1 4)) VALUE('STOP')      */              /*CRE026 CCB023*/
/**********     GOTO       CMDLBL(NEXT2)                           */              /*CRE026 CCB023*/
/**********  ENDDO                                                 */              /*CRE026 CCB023*/
                                                                                          /*CRE026*/
/**********  DLCOBJ     OBJ((GLNOSTPD *FILE *EXCL))                */              /*CRE026 CCB023*/
/**********  MONMSG     MSGID(CPF0000 MCH0000 RPG0000)             */              /*CRE026 CCB023*/
/*******************************************************************          */ /*CRE026 MD021155*/
/***NEXT2:*                                                                   */ /*CRE026 MD021155*/
/*******************************************************************          */ /*CRE026 MD021155*/
/**********  ALCOBJ     OBJ((GLCYPNPD *FILE *EXCL)) WAIT(0)        */              /*CRE026 CCB023*/
/**********  MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)    */              /*CRE026 CCB023*/
/**********  CHGDTAARA  DTAARA(GLCYPNCTL (1 4)) VALUE('STOP')      */              /*CRE026 CCB023*/
/**********       GOTO       CMDLBL(NEXT3)                         */              /*CRE026 CCB023*/
/**********  ENDDO                                                 */              /*CRE026 CCB023*/
                                                                                          /*CRE026*/
/**********  DLCOBJ     OBJ((GLCYPNPD *FILE *EXCL))                */              /*CRE026 CCB023*/
/**********  MONMSG     MSGID(CPF0000 MCH0000 RPG0000)             */              /*CRE026 CCB023*/
/*******************************************************************          */ /*CRE026 MD021155*/
/***NEXT3:*                                                                   */ /*CRE026 MD021155*/
/*******************************************************************          */ /*CRE026 MD021155*/
 /**Check*Lock*on*PF/SDCBTRPD**/                                                   /*CRE026 CCB023*/
/**********   ALCOBJ     OBJ((SDCBTRPD *FILE *EXCL)) WAIT(0)       */              /*CRE026 CCB023*/
/**********   MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)   */              /*CRE026 CCB023*/
 /**Send*Data*to*Dataqueue**/                                                      /*CRE026 CCB023*/
/**********   CALL       PGM(QSNDDTAQ) PARM(&NAME &LIB +
                           &MSGLENGTH &MSGDATA)                    */              /*CRE026 CCB023*/
/**********      GOTO       CMDLBL(NEXT4)                          */              /*CRE026 CCB023*/
/**********   ENDDO                                                */              /*CRE026 CCB023*/
                                                                                          /*CRE026*/
/**********   DLCOBJ     OBJ((SDCBTRPD *FILE *EXCL))                               /*CRE026 CCB023*/
/*******************************************************************          */ /*CRE026 MD021155*/
/***NEXT4:*                                                                   */ /*CRE026 MD021155*/
/*******************************************************************          */ /*CRE026 MD021155*/
/**********  ENDDO                                                 */            /*BUG12215 CCB023*/
             ALCOBJ     OBJ((GOOSJSPD *FILE *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
/**********  SNDJRNE    JRN(ICJRN) TYPE('OS') ENTDTA(&MSG) */                            /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE('OS') ENTDTA(&MSG) +
                          FORCE(*YES)                                                    /*BUG9619*/
                GOTO       CMDLBL(END)
             ENDDO
 
             DLCOBJ     OBJ((GOOSJSPD *FILE *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
/* Check if CSD031 is on.                                                */  /*CSD031*/ /*BUG12461*/
/**********                                                              */  /*CSD031*/ /*BUG12461*/
/**********  CHGVAR     VAR(&PRTCD) VALUE('       ')                     */  /*CSD031*/ /*BUG12461*/
/**********  CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                     */  /*CSD031*/ /*BUG12461*/
/**********  CHGVAR     VAR(&PSARD) VALUE('CSD031')                      */  /*CSD031*/ /*BUG12461*/
/**********                                                              */  /*CSD031*/ /*BUG12461*/
/**********  CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &DSFDY)  */  /*CSD031*/ /*BUG12461*/
/**********                                                              */  /*CSD031*/ /*BUG12461*/
/* Try to end the acceptance job if CSD031 is on.                        */  /*CSD031*/ /*BUG12461*/
/**********                                                              */  /*CSD031*/ /*BUG12461*/
/**********  IF         COND(&PRTCD *EQ '       ') THEN(CALL +
                          PGM(SDC000060E))                               */  /*CSD031*/ /*BUG12461*/
/**********  ELSE       CMD(IF COND(&PRTCD *NE '*NRF   ') THEN(GOTO +
                          CMDLBL(ABNOR)))                                */  /*CSD031*/ /*BUG12461*/
/**********                                                              */  /*CSD031*/ /*BUG12461*/
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
