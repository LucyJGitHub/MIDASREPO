/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SM Update "run" status on new SCSARPPD')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC0865 - Update 'run' status on new SCSARPPD               */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD056555           Date 31Aug20              */
/*       Prev Amend No. MD054605           Date 17Oct19              */
/*                      MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CUP034             Date 24Jan07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CUP033             Date 30Jun06              */
/*                      CSM005             Date 21Sep05              */
/*                      CSM003             Date 30May05              */
/*                      CUP016 *CREATE     Date 01Apr03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD056555 - Deliverable Data Split for SAR group             */
/*       MD054605 - Deliverable Data Split for SDSVALPD              */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP034 - Reduce size of implementation library.             */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CSM003 - Use system value rather than UPSTAT.               */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CUP033*/
             PGM        PARM(&PFXSVAL &OPFXSVAL)                                          /*CUP033*/

             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
             DCL        VAR(&OPFXSVAL) TYPE(*CHAR) LEN(20)                                /*CUP033*/

/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*             */ /*CUP033*/
/**********  DCL        VAR(&UPSTAT) TYPE(*CHAR) LEN(256)                              */ /*CSM003*/
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&OLDSBSID) TYPE(*CHAR) LEN(2)                                 /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
             DCL        VAR(&FDTALIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FCMPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SCMPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FWHICHLIB) TYPE(*CHAR) LEN(3)
/**********  DCL        VAR(&NEWPFX) TYPE(*CHAR) LEN(2)                                */ /*CSM003*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
             DCL        VAR(&SQLSTM) TYPE(*CHAR) LEN(80)                                /*MD056555*/

/**********  DCLF       FILE(UPSVALJ0) */                                      /*CUP033* *MD054605*/
             DCLF       FILE(UPSVALJ0) ALWNULL(*YES)                                    /*MD054605*/

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
                                                                                        /*MD056555*/
/* Set up file for SQL statements. */                                                   /*MD056555*/
             DLTF       FILE(QTEMP/RUNSQLSTM)                                           /*MD056555*/
             MONMSG     MSGID(CPF0000)                                                  /*MD056555*/
             DLTF       FILE(QTEMP/RUNSQL)                                              /*MD056555*/
             MONMSG     MSGID(CPF0000)                                                  /*MD056555*/
             CRTSRCPF   FILE(QTEMP/RUNSQLSTM) RCDLEN(112) +
                          MBR(RUNSQLSTM) TEXT('Temporary source +
                          file for UTC000001')                                          /*MD056555*/
             RNMOBJ     OBJ(QTEMP/RUNSQLSTM) OBJTYPE(*FILE) +
                          NEWOBJ(RUNSQL)                                                /*MD056555*/

/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*             */ /*CUP033*/
/**COPY*UPCPYSRC,UPSVALCAL3*                                         */ /*  */ /*CSM003*/ /*CUP033*/

/**Check*if*all*relevant*fields*have*been*entered*in*ICD**/ /*                         */ /*CUP033*/
/**********  IF         COND(&SBSID *EQ ' ' *OR &PTFUPG *EQ ' ') +                     */ /*CSM003*/
/**********               THEN(DO)                                                     */ /*CSM003*/
/**********  IF         COND(&SBSID *EQ ' ' *OR &PTFUPG *EQ ' ' *OR +                  */ /*CUP033*/
/**********               &OLDSBSID *EQ ' ') THEN(DO)                       */ /*CSM003*/ /*CUP033*/
/**Set*up*messages*for*Midas*Information*Screen***/ /*                                 */ /*CUP033*/

VALIDATE:                                                                                 /*CUP033*/
             RCVF                                                                         /*CUP033*/
             MONMSG     MSGID(CPF0864) EXEC(DO)                                           /*CUP033*/
                GOTO       CMDLBL(CHECK)                                                  /*CUP033*/
             ENDDO                                                                        /*CUP033*/

             IF         COND(&GISVAL *EQ &PFXSVAL) THEN(DO)                               /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&SBSID) VALUE(&GIVAL)                                   /*CUP033*/
                ENDDO                                                                     /*CUP033*/
             ENDDO                                                                        /*CUP033*/

             IF         COND(&GISVAL *EQ &OPFXSVAL) THEN(DO)                              /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&OLDSBSID) VALUE(&GIVAL)                                /*CUP033*/
                ENDDO                                                                     /*CUP033*/
             ENDDO                                                                        /*CUP033*/

             GOTO       CMDLBL(VALIDATE)                                                  /*CUP033*/

 CHECK:                                                                                   /*CUP033*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                                 /*CUP033*/
                RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)
                CALL       PGM(SCC0010) PARM('SMC0865' 'ENTER' ' ')
                GOTO       CMDLBL(END)
             ENDDO

/* Set up library list. */                                                                /*CUP034*/
             CALL       PGM(UPC0014) PARM(&SBSID)                                         /*CUP034*/

/**Retrieve*'new'*prefix*from*data*area*UPSTAT.**/ /*                                  */ /*CSM003*/
/**********  RTVDTAARA  DTAARA(&PTFUPG/UPSTAT) RTNVAR(&UPSTAT)                         */ /*CSM003*/
/**********  CHGVAR     VAR(&NEWPFX) VALUE(%SST(&UPSTAT 62 2))                         */ /*CSM003*/
/**********  IF         COND(&NEWPFX *EQ ' ') THEN(DO)                                 */ /*CSM003*/
/**********     CHGVAR     VAR(&NEWPFX) VALUE(%SST(&UPSTAT 60 2))                      */ /*CSM003*/
/**********  ENDDO                                                                     */ /*CSM003*/

/* Check where logical files exist. */
/**********  CHGVAR     VAR(&FDTALIB) VALUE(&SBSID *TCAT 'DTALIB')                     */ /*CSM003*/
/**********  CHGVAR     VAR(&SCMPLIB) VALUE(&NEWPFX *TCAT 'DVLIB')                     */ /*CSM003*/
             CHGVAR     VAR(&FDTALIB) VALUE(&OLDSBSID *TCAT 'DTALIB')                     /*CSM003*/
             CHGVAR     VAR(&SCMPLIB) VALUE(&SBSID *TCAT 'DVLIB')                         /*CSM003*/

/**********  CHKOBJ     OBJ(&FDTALIB/SCSARPL1) OBJTYPE(*FILE) */                        /*MD056555*/
/**********  MONMSG     MSGID(CPF9801) EXEC(DO) */                                      /*MD056555*/
/**********     CHGVAR     VAR(&FWHICHLIB) VALUE('DV ') */                              /*MD056555*/
/**********  ENDDO */                                                                   /*MD056555*/

             IF         COND(&FWHICHLIB *EQ 'DV ') THEN(DO)
/**********     CHGVAR     VAR(&FCMPLIB) VALUE(&SBSID *TCAT 'DVLIB')                   */ /*CSM003*/
                CHGVAR     VAR(&FCMPLIB) VALUE(&OLDSBSID *TCAT 'DVLIB')                   /*CSM003*/
             ENDDO
             ELSE       CMD(DO)
/**********     CHGVAR     VAR(&FCMPLIB) VALUE(&SBSID *TCAT 'DTALIB')                  */ /*CSM003*/
                CHGVAR     VAR(&FCMPLIB) VALUE(&OLDSBSID *TCAT 'DTALIB')                  /*CSM003*/
             ENDDO

/* Override files before call to update 'new' SCSARPPD. */
/**********  OVRDBF     FILE(SARP1) TOFILE(&FCMPLIB/SCSARPL1) */                        /*MD056555*/
/**********  OVRDBF     FILE(SARP2) TOFILE(&SCMPLIB/SCSARPL1) */                        /*MD056555*/

/**********  CALL       PGM(SM0865) */                                                  /*MD056555*/

/* is SDSRPXTD present in the old system? */                                            /*MD056555*/
             CHGVAR     VAR(&FDTALIB) VALUE(&OLDSBSID *TCAT 'DMLIB')                    /*MD056555*/
             CHKOBJ     OBJ(&FDTALIB/SCSRPXTD) OBJTYPE(*FILE)                           /*MD056555*/
/* if no */                                                                             /*MD056555*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                         /*MD056555*/
             CHGVAR     VAR(&FDTALIB) VALUE(&OLDSBSID *TCAT 'DTALIB')                   /*MD056555*/
                CHGVAR     VAR(&FCMPLIB) VALUE(&SBSID *TCAT 'DMLIB')                    /*MD056555*/
             CHGVAR     VAR(&SQLSTM) VALUE('UPDATE ' *BCAT &FCMPLIB +
                        *TCAT '/SCSRPXTD a set a.akprvc = ')                            /*MD056555*/
             CALL       PGM(UTWRTSQL) PARM(&SQLSTM '*CLEAR')                            /*MD056555*/
             CHGVAR     VAR(&SQLSTM) VALUE('(select b.akprvc  +
                        from '  *CAT &FDTALIB *TCAT '/SCSARPPD b where ')               /*MD056555*/
             CALL       PGM(UTWRTSQL) PARM(&SQLSTM '*WRITE')                            /*MD056555*/
             CHGVAR     VAR(&SQLSTM) VALUE(' a.aksarn  +
                         = b.aksarn and a.akpnam = b.akpnam)')                          /*MD056555*/
             CALL       PGM(UTWRTSQL) PARM(&SQLSTM '*WRITE')                            /*MD056555*/
             CHGVAR     VAR(&SQLSTM) VALUE(' where exists ( +
                         select * from ' *CAT &FDTALIB *TCAT '/SCSARPPD b ')            /*MD056555*/
             CALL       PGM(UTWRTSQL) PARM(&SQLSTM '*WRITE')                            /*MD056555*/
             CHGVAR     VAR(&SQLSTM) VALUE(' where   +
                         a.aksarn = b.aksarn and a.akpnam = b.akpnam)')                 /*MD056555*/
             CALL       PGM(UTWRTSQL) PARM(&SQLSTM '*WRITE')                            /*MD056555*/
             RUNSQLSTM  SRCFILE(RUNSQL) SRCMBR(RUNSQLSTM) COMMIT(*NONE)                 /*MD056555*/
             GOTO       CMDLBL(END)                                                     /*MD056555*/
             ENDDO                                                                      /*MD056555*/
/* if yes */                                                                            /*MD056555*/
             CHGVAR     VAR(&FDTALIB) VALUE(&OLDSBSID *TCAT 'DMLIB')                    /*MD056555*/
             CHGVAR     VAR(&FCMPLIB) VALUE(&SBSID *TCAT 'DMLIB')                       /*MD056555*/
             CHGVAR     VAR(&SQLSTM) VALUE('UPDATE ' *BCAT &FCMPLIB +
                        *TCAT '/SCSRPXTD a set a.akprvc = ')                            /*MD056555*/
             CALL       PGM(UTWRTSQL) PARM(&SQLSTM '*CLEAR')                            /*MD056555*/
             CHGVAR     VAR(&SQLSTM) VALUE('(select b.akprvc  +
                        from '  *CAT &FDTALIB *TCAT '/SCSRPXTD b where ')               /*MD056555*/
             CALL       PGM(UTWRTSQL) PARM(&SQLSTM '*WRITE')                            /*MD056555*/
             CHGVAR     VAR(&SQLSTM) VALUE(' a.aksarn  +
                         = b.aksarn and a.akpnam = b.akpnam)')                          /*MD056555*/
             CALL       PGM(UTWRTSQL) PARM(&SQLSTM '*WRITE')                            /*MD056555*/
             CHGVAR     VAR(&SQLSTM) VALUE(' where exists ( +
                         select * from ' *CAT &FDTALIB *TCAT '/SCSRPXTD b ')            /*MD056555*/
             CALL       PGM(UTWRTSQL) PARM(&SQLSTM '*WRITE')                            /*MD056555*/
             CHGVAR     VAR(&SQLSTM) VALUE(' where   +
                         a.aksarn = b.aksarn and a.akpnam = b.akpnam)')                 /*MD056555*/
             CALL       PGM(UTWRTSQL) PARM(&SQLSTM '*WRITE')                            /*MD056555*/
             RUNSQLSTM  SRCFILE(RUNSQL) SRCMBR(RUNSQLSTM) COMMIT(*NONE)                 /*MD056555*/
             GOTO       CMDLBL(END)                                                     /*MD056555*/
                                                                                        /*MD056555*/
             DLTOVR     FILE(*ALL)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO

             GOTO       CMDLBL(END)

ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('SMC0865') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('SMC0865' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000)

END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
