/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF - Extract Market by Market')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting 5luxembourg)                     */
/*                                                                   */
/*       ERCLUFF - FF extraction Market by Market                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. ULX008             Date 18Apr00              */
/*                      ULX008             Date 22Feb00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX008 - "Commissariat aux Bourses" - Change Control B      */
/*       ULX008 - CSSF Statutory Reporting : Commissariat aux Bourses*/
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PDATE)
 
             DCL        VAR(&PDATE) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(8)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
/* Midas FF Market Centres */
             DCLF       FILE(MARKTD)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
 
/**/
/* Process OTC Member with TRANSDY6                         */
/**/
/**********  CHGVAR     VAR(&FILE) VALUE(TRANSDY6)                                        /*CER001*/
/**********  CHKOBJ     OBJ(TRANSDY6) OBJTYPE(*FILE) MBR(OTC)                             /*CER001*/
             CHGVAR     VAR(&FILE) VALUE(FFTRX2L0)                                        /*CER001*/
             CHKOBJ     OBJ(FFTRX2L0) OBJTYPE(*FILE) MBR(OTC)                             /*CER001*/
             MONMSG     MSGID(CPF9815) EXEC(DO)
/**********       CHGVAR     VAR(&FILE) VALUE(TRANSDY6)                                   /*CER001*/
                  CHGVAR     VAR(&FILE) VALUE(FFTRX2L0)                                   /*CER001*/
                  CHGVAR     VAR(&MEMBER) VALUE(OTC)
                  GOTO       CMDLBL(MISM)
                  ENDDO
 
/***  Setup OTC memberS  ***/
 
        CHGVAR     VAR(&MEMBER) VALUE(OTC)
        OVRDBF     FILE(TRANS7)  MBR(OTC)
        OVRDBF     FILE(TRSET )  MBR(OTC)
/**********OVRDBF     FILE(TRANSDY6)  MBR(OTC)                                            /*CER001*/
        OVRDBF     FILE(FFTRX2L0)  MBR(OTC)                                               /*CER001*/
        CALL       PGM(ERLUFF) PARM(&PDATE)
        IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             SNDPGMMSG  MSG('Program ERCLUFF abnormally Terminated +
                        in OTC. See DUMP') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             DLTOVR     FILE(TRANS7)
             DLTOVR     FILE(TRSET )
/**********  DLTOVR     FILE(TRANSDY6)                                                    /*CER001*/
             DLTOVR     FILE(FFTRX2L0)                                                    /*CER001*/
             GOTO       ABNOR
        ENDDO
        DLTOVR     FILE(TRANS7)
        DLTOVR     FILE(TRSET )
/**********DLTOVR     FILE(TRANSDY6)                                                      /*CER001*/
        DLTOVR     FILE(FFTRX2L0)                                                         /*CER001*/
 
/* Loop to Process All Market Centres (in MARKTD)                   */
 
 LOOP1:      RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
/*** setup not deleted market center  ***/
 
             IF         COND(&RECI *NE '*') THEN(DO)
                  CHGVAR     VAR(&MKT) VALUE(&MRKT)
/**********       CHKOBJ     OBJ(TRANSDY6) OBJTYPE(*FILE) MBR(&MKT)                       /*CER001*/
                  CHKOBJ     OBJ(FFTRX2L0) OBJTYPE(*FILE) MBR(&MKT)                       /*CER001*/
                  MONMSG     MSGID(CPF9815) EXEC(DO)  /*** not found, add it ***/
/**********           ADDPFM     FILE(TRANSDX6) MBR(&MKT)                                 /*CER001*/
/**********           ADDLFM     FILE(TRANSDY6) MBR(&MKT) DTAMBRS((TRANSDX6 +             /*CER001*/
                      ADDPFM     FILE(FFTRX2PD) MBR(&MKT)                                 /*CER001*/
                      ADDLFM     FILE(FFTRX2L0) MBR(&MKT) DTAMBRS((FFTRX2PD +
                                (&MKT)))
                      ENDDO
 
/***  Setup Market member  ***/
 
                  CHGVAR     VAR(&MEMBER) VALUE(&MKT)
                  OVRDBF     FILE(TRANS7)  MBR(&MKT)
                  OVRDBF     FILE(TRSET )  MBR(&MKT)
/**********       OVRDBF     FILE(TRANSDY6)  MBR(&MKT)                                    /*CER001*/
                  OVRDBF     FILE(FFTRX2L0)  MBR(&MKT)                                    /*CER001*/
                  CALL       PGM(ERLUFF) PARM(&PDATE)
                  IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  SNDPGMMSG  MSG('Program ERCLUFF abnormally Terminated +
                             in ' *CAT &MKT *CAT '. See DUMP') +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                  DLTOVR     FILE(TRANS7)
                  DLTOVR     FILE(TRSET )
/**********       DLTOVR     FILE(TRANSDY6)                                               /*CER001*/
                  DLTOVR     FILE(FFTRX2L0)                                               /*CER001*/
                  GOTO       ABNOR
                  ENDDO
                  DLTOVR     FILE(TRANS7)
                  DLTOVR     FILE(TRSET )
/**********       DLTOVR     FILE(TRANSDY6)                                               /*CER001*/
                  DLTOVR     FILE(FFTRX2L0)                                               /*CER001*/
                  ENDDO
 
/***  Read next Market  ***/
 
             GOTO       CMDLBL(LOOP1)
 
 MISM:       SNDPGMMSG  MSG('Program ERCLUFF ended abnormally, +
                          missing *File ' *CAT &FILE *BCAT +
                          '*Member' *BCAT &MEMBER) TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             GOTO       CMDLBL(END)
 
 ABNOR:
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          ERCLUFF ended abnormally - see job +
                          log') TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd. 2005')
 
             ENDPGM
