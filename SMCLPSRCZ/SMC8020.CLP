/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SM Check for duplicate records')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC8020 - Check for duplicate fields                        */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD054605           Date 17Oct19              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CUP038             Date 27Jul07              */
/*                      CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSM005             Date 21Sep05              */
/*                      CSM003             Date 30May05              */
/*                      CUP020  *CREATE    Date 03Jan03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD054605 - Deliverable Data Split for SDSVALPD              */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP038 - MITEM will not be found if migrating from Midas +  */
/*                system so bypass error processing.                 */
/*       CUP033 - Removal of System Value /COPYs                     */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CSM003 - Use system value rather than UPSTAT.               */
/*       CUP020 - Additional changes for Action Files                */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CUP033*/
             PGM        PARM(&PFXSVAL &OPFXSVAL)                                          /*CUP033*/

             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
             DCL        VAR(&OPFXSVAL) TYPE(*CHAR) LEN(20)                                /*CUP033*/
/**COPY*UPCPYSRG,UPSVALDCL*                                          */ /*             */ /*CUP033*/
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&OLDSBSID) TYPE(*CHAR) LEN(2)                                 /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')

/**********  DCLF       FILE(UPSVALJ0) */                                      /*CUP033* *MD054605*/
             DCLF       FILE(UPSVALJ0) ALWNULL(*YES)                                    /*MD054605*/

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)

             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')

/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*             */ /*CUP033*/
/**COPY*UPCPYSRC,UPSVALCAL3*                                         */ /*  */ /*CSM003*/ /*CUP033*/
/**********  IF         COND(&SBSID *EQ ' ') THEN(DO)                                  */ /*CSM003*/
/**********  IF         COND(&OLDSBSID *EQ ' ') THEN(DO)                    */ /*CSM003*/ /*CUP033*/

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
                CALL       PGM(SCC0010) PARM('SMC8020' 'ENTER' ' ')
                GOTO       CMDLBL(END)
             ENDDO

/* Set up library list. */                                                                /*CUP033*/
             CALL       PGM(UPC0014) PARM(&SBSID)                                         /*CUP033*/

/**********  CHGVAR     VAR(&DTALIB) VALUE(&SBSID *TCAT 'DTALIB')                      */ /*CSM003*/
             CHGVAR     VAR(&DTALIB) VALUE(&OLDSBSID *TCAT 'DTALIB')                      /*CSM003*/

CBDPRLPD:
             OVRDBF     FILE(CBDPRLPD) TOFILE(&DTALIB/CBDPRLPD) +
                          SHARE(*YES)
             OPNQRYF    FILE((CBDPRLPD)) KEYFLD((DIDSON) (DIDSOS) +
                          (DIDDON) (DIDDOS))
             CALL       PGM(SM8020)
             CLOF       OPNID(CBDPRLPD)
             DLTOVR     FILE(CBDPRLPD)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
CBMEXCPD:
             OVRDBF     FILE(CBMEXCPD) TOFILE(&DTALIB/CBMEXCPD) +
                          SHARE(*YES)
             OPNQRYF    FILE((CBMEXCPD)) KEYFLD((DKCOTT) (DKCSEQ) +
                          (DKMECN) (DKMECS))
             CALL       PGM(SM8022)
             CLOF       OPNID(CBMEXCPD)
             DLTOVR     FILE(CBMEXCPD)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
MITEMDD:
/* Check where logical file exists. */
             CHKOBJ     OBJ(&DTALIB/MITEM) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
/**********     CHGVAR     VAR(&DTALIB) VALUE(&SBSID *TCAT 'DVLIB')                    */ /*CSM003*/
                CHGVAR     VAR(&DTALIB) VALUE(&OLDSBSID *TCAT 'DVLIB')                    /*CSM003*/
                CHKOBJ     OBJ(&DTALIB/MITEM) OBJTYPE(*FILE)                              /*CUP038*/
                MONMSG     MSGID(CPF9801) EXEC(DO)                                        /*CUP038*/
                   GOTO       CMDLBL(END)                                                 /*CUP038*/
                ENDDO                                                                     /*CUP038*/
             ENDDO
             OVRDBF     FILE(MITEM) TOFILE(&DTALIB/MITEM)
             CALL       PGM(SM8021)
             DLTOVR     FILE(MITEM)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
             GOTO       CMDLBL(END)

ABNOR:
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('SMC8020') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('SMC8020' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000 MCH0000)

END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

             ENDPGM
