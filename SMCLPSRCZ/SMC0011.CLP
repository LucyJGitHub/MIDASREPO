/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SM Check contents of "to" DTALIB - shell')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC0011 - Check contents of "to" DTALIB - shell             */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. BUG27791           Date 28May10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CUP033             Date 30Aug06              */
/*                      CUP016 *CREATE     Date 01Apr03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG27791 - Identify 'from' release more easily              */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                     */ /*BUG27791*/
             PGM        PARM(&ORLVLSVAL)                                                /*BUG27791*/
 
             DCL        VAR(&ORLVLSVAL) TYPE(*CHAR) LEN(20)                             /*BUG27791*/
 
             DCL        VAR(&OLDRLVL) TYPE(*CHAR) LEN(22)                               /*BUG27791*/
/**********  DCL        VAR(&RELEASE) TYPE(*CHAR) LEN(1)                             */ /*BUG27791*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                   /*BUG27791*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
             DCLF       FILE(UPSVALJ0)                                                  /*BUG27791*/
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)
 
/* Create data area /MIDASMSG in QTEMP */
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')
 
/* Check that System Values have an entry. */                                           /*BUG27791*/
VALIDATE:                                                                               /*BUG27791*/
             RCVF                                                                       /*BUG27791*/
             MONMSG     MSGID(CPF0864) EXEC(DO)                                         /*BUG27791*/
                GOTO       CMDLBL(CHECK)                                                /*BUG27791*/
             ENDDO                                                                      /*BUG27791*/
 
             IF         COND(&GISVAL *EQ &ORLVLSVAL) THEN(DO)                           /*BUG27791*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                /*BUG27791*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                /*BUG27791*/
                ENDDO                                                                   /*BUG27791*/
                ELSE       CMD(DO)                                                      /*BUG27791*/
                   CHGVAR     VAR(&OLDRLVL) VALUE(&GIVAL)                               /*BUG27791*/
                ENDDO                                                                   /*BUG27791*/
             ENDDO                                                                      /*BUG27791*/
 
             GOTO       CMDLBL(VALIDATE)                                                /*BUG27791*/
 
 CHECK:                                                                                 /*BUG27791*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                               /*BUG27791*/
                RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)                    /*BUG27791*/
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)                    /*BUG27791*/
                RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)                    /*BUG27791*/
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)                    /*BUG27791*/
                CALL       PGM(SCC0010) PARM('SMC0011' 'ENTER' ' ')                     /*BUG27791*/
                GOTO       CMDLBL(END)                                                  /*BUG27791*/
             ENDDO                                                                      /*BUG27791*/
 
/* Check if "from" system is Release 04 or earlier. */
/**********  RTVDTAARA  DTAARA(UPSTAT (79 1)) RTNVAR(&RELEASE)                       */ /*BUG27791*/
/**********  IF         COND(&RELEASE *EQ 'P') THEN(DO)                              */ /*BUG27791*/
             IF         COND(%SST(&OLDRLVL 1 10) *EQ 'Midas     ' +
                          *AND %SST(&OLDRLVL 11 10) *NE 'R4') THEN(DO)                  /*BUG27791*/
/**********     CALL       PGM(SMC0012)                                                */ /*CUP033*/
                CALL       PGM(SMC0012) PARM('BrgMidasSystemPrefix' +
                             'BrgOldZonePrefix')                                          /*CUP033*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
/**********  IF         COND(&RELEASE *EQ '4') THEN(DO)                                */ /*CUP033*/
/**********     CALL       PGM(SMC0006) PARM('DT')                                     */ /*CUP033*/
/**********  IF         COND(&RELEASE *EQ '4' *OR &RELEASE = ' ') +                  */ /*BUG27791*/
/**********               THEN(DO)                                        */ /*CUP033*/ /*BUG27791*/
             ELSE       CMD(DO)                                                         /*BUG27791*/
                CALL       PGM(SMC0006) PARM('DT' +
                             'BrgMidasSystemPrefix' 'BrgOldZonePrefix')                   /*CUP033*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
             GOTO       CMDLBL(END)
ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('SMC0011') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('SMC0011' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
