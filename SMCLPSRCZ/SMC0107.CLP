/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SM Database cross reference - shell')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC0107 - Database cross reference, shell                   */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. BUG27791           Date 28May10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CUP034             Date 24Jan07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CUP033             Date 06Jul06              */
/*                      CSM003             Date 14Jun05              */
/*                      CUP016 *CREATE     Date 01Apr03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG27791 - Identify 'from' release more easily              */
/*       CUP034 - Reduce size of implementation library.             */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CSM003 - Use system value rather than UPSTAT.               */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CUP034*/
/**********  PGM        PARM(&PFXSVAL &OPFXSVAL)                          */ /*CUP034*/ /*BUG27791*/
             PGM        PARM(&PFXSVAL &OPFXSVAL &ORLVLSVAL)                             /*BUG27791*/
 
             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP034*/
             DCL        VAR(&OPFXSVAL) TYPE(*CHAR) LEN(20)                                /*CUP034*/
             DCL        VAR(&ORLVLSVAL) TYPE(*CHAR) LEN(20)                             /*BUG27791*/
 
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP034*/
             DCL        VAR(&OLDSBSID) TYPE(*CHAR) LEN(2)                                 /*CUP034*/
             DCL        VAR(&OLDRLVL) TYPE(*CHAR) LEN(22)                               /*BUG27791*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP034*/
             DCL        VAR(&DVLIB) TYPE(*CHAR) LEN(10)                                   /*CUP034*/
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)                                  /*CUP034*/
             DCL        VAR(&NOFILE) TYPE(*CHAR) LEN(1)                                   /*CUP034*/
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)                                   /*CUP034*/
/**********  DCL        VAR(&RELEASE) TYPE(*CHAR) LEN(1)                                /*BUG27791*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
             DCLF       FILE(UPSVALJ0)                                                    /*CUP034*/
 
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
 
VALIDATE:                                                                                 /*CUP034*/
             RCVF                                                                         /*CUP034*/
             MONMSG     MSGID(CPF0864) EXEC(DO)                                           /*CUP034*/
                GOTO       CMDLBL(CHECK)                                                  /*CUP034*/
             ENDDO                                                                        /*CUP034*/
 
             IF         COND(&GISVAL *EQ &PFXSVAL) THEN(DO)                               /*CUP034*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP034*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP034*/
                ENDDO                                                                     /*CUP034*/
                ELSE       CMD(DO)                                                        /*CUP034*/
                   CHGVAR     VAR(&SBSID) VALUE(&GIVAL)                                   /*CUP034*/
                ENDDO                                                                     /*CUP034*/
             ENDDO                                                                        /*CUP034*/
 
             IF         COND(&GISVAL *EQ &OPFXSVAL) THEN(DO)                              /*CUP034*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP034*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP034*/
                ENDDO                                                                     /*CUP034*/
                ELSE       CMD(DO)                                                        /*CUP034*/
                   CHGVAR     VAR(&OLDSBSID) VALUE(&GIVAL)                                /*CUP034*/
                ENDDO                                                                     /*CUP034*/
             ENDDO                                                                        /*CUP034*/
 
             IF         COND(&GISVAL *EQ &ORLVLSVAL) THEN(DO)                           /*BUG27791*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                /*BUG27791*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                /*BUG27791*/
                ENDDO                                                                   /*BUG27791*/
                ELSE       CMD(DO)                                                      /*BUG27791*/
                   CHGVAR     VAR(&OLDRLVL) VALUE(&GIVAL)                               /*BUG27791*/
                ENDDO                                                                   /*BUG27791*/
             ENDDO                                                                      /*BUG27791*/
 
             GOTO       CMDLBL(VALIDATE)                                                  /*CUP034*/
 
 CHECK:                                                                                   /*CUP034*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                                 /*CUP034*/
                RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)                      /*CUP034*/
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)                      /*CUP034*/
                RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)                      /*CUP034*/
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)                      /*CUP034*/
                CALL       PGM(SCC0010) PARM('SMC0107' 'ENTER' ' ')                       /*CUP034*/
                GOTO       CMDLBL(END)                                                    /*CUP034*/
             ENDDO                                                                        /*CUP034*/
 
/* Set up library list. */                                                                /*CUP034*/
             CALL       PGM(UPC0014) PARM(&SBSID)                                         /*CUP034*/
 
             CHGVAR     VAR(&DVLIB) VALUE(&OLDSBSID *TCAT 'DVLIB')                        /*CUP034*/
             CHGVAR     VAR(&DTALIB) VALUE(&OLDSBSID *TCAT 'DTALIB')                      /*CUP034*/
 
/* Create user spaces */                                                                  /*CUP034*/
             CRTUSRSPC  USRSPC(QTEMP/DBR) DELETE(*YES)                                    /*CUP034*/
 
/* Display file description for logical files in DV and DTA libs.    */                   /*CUP034*/
             DSPFD      FILE(&DVLIB/*ALL) TYPE(*ACCPTH) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/UPFDAPOF)                        /*CUP034*/
             MONMSG     MSGID(CPF3012) EXEC(DO)                                           /*CUP034*/
                CHGVAR     VAR(&NOFILE) VALUE('Y')                                        /*CUP034*/
             ENDDO                                                                        /*CUP034*/
             DSPFD      FILE(&DTALIB/*ALL) TYPE(*ACCPTH) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/UPFDAPOF) +
                          OUTMBR(*FIRST *ADD)                                             /*CUP034*/
             MONMSG     MSGID(CPF3012) EXEC(DO)                                           /*CUP034*/
                IF         COND(&NOFILE *NE 'Y') THEN(DO)                                 /*CUP034*/
                   DSPFD      FILE(QAFDACCP) TYPE(*MBR) OUTPUT(*OUTFILE) +
                                OUTFILE(QTEMP/UPFDAPOF)                                   /*CUP034*/
                   CLRPFM     FILE(QTEMP/UPFDAPOF)                                        /*CUP034*/
                ENDDO                                                                     /*CUP034*/
             ENDDO                                                                        /*CUP034*/
 
/* Check if "from" system is Release 04 or earlier. */
/**********  RTVDTAARA  DTAARA(UPSTAT (79 1)) RTNVAR(&RELEASE)                       */ /*BUG27791*/
/**********  IF         COND(&RELEASE *EQ 'P') THEN(DO)                              */ /*BUG27791*/
             IF         COND(%SST(&OLDRLVL 1 10) *EQ 'Midas     ' +
                          *AND %SST(&OLDRLVL 11 10) *NE 'R4') THEN(DO)                  /*BUG27791*/
/**********     CALL       PGM(SMC0108)                                                */ /*CUP033*/
/**********     CALL       PGM(SMC0108) PARM('BrgOldZonePrefix')            */ /*CUP033*/ /*CUP034*/
/**********     IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                            */ /*CUP034*/
/**********        GOTO       CMDLBL(ABNOR)                                            */ /*CUP034*/
/**********     ENDDO                                                                  */ /*CUP034*/
                CALL       PGM(SM0108) PARM(&OLDSBSID &RETURN)                            /*CUP034*/
             ENDDO
/**********  IF         COND(&RELEASE *EQ '4') THEN(DO)                                */ /*CSM003*/
/**********     CALL       PGM(UPC0108)                                                */ /*CSM003*/
/**********     CALL       PGM(SMC0109)                                     */ /*CSM003*/ /*CUP033*/
/**********  IF         COND(&RELEASE *EQ '4' *OR &RELEASE *EQ ' ') +                */ /*BUG27791*/
/**********               THEN(DO)                                        */ /*CSM003*/ /*BUG27791*/
             ELSE       CMD(DO)                                                         /*BUG27791*/
/**********     CALL       PGM(SMC0109) PARM('BrgOldZonePrefix')            */ /*CUP033*/ /*CUP034*/
                CALL       PGM(UP000108) PARM(&OLDSBSID '*ZONE' &RETURN)                  /*CUP034*/
                CHGSPLFA   FILE(UP0108P1) SPLNBR(*LAST) USRDTA('UP0108')                  /*CUP034*/
                MONMSG     MSGID(CPF0000)                                                 /*CUP034*/
             ENDDO
 
             IF         COND(&RETURN *NE ' ') THEN(DO)                                    /*CUP034*/
                GOTO       CMDLBL(ABNOR)                                                  /*CUP034*/
             ENDDO                                                                        /*CUP034*/
 
             GOTO       CMDLBL(END)
ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('SMC0107') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('SMC0107' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
