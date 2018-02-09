/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF - Setup TRANSDX6 multi-members file')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Futures and Options Module                          */
/*                                                                   */
/*       FFC0020X6 - SETUP FFTRX2PD multi-member based on market     */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX008             Date 22Feb00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX008 - CSSF Statutory Reporting : Commissariat aux Bourses*/
/*                                                                   */
/*********************************************************************/
             PGM PARM(&PRTCD &PMOD)
 
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PMOD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(8)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/* Midas FF Market Centres */
             DCLF       FILE(MARKTD)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
 
/**/
/* Process OTC Member with TRANSD                           */
/**/
/**********  CHKOBJ     OBJ(TRANSDX6) OBJTYPE(*FILE) MBR(OTC)                             /*CER001*/
             CHKOBJ     OBJ(FFTRX2PD) OBJTYPE(*FILE) MBR(OTC)                             /*CER001*/
             MONMSG     MSGID(CPF9815) EXEC(DO)
/**********       CHGVAR     VAR(&FILE) VALUE(TRANSDX6)                                   /*CER001*/
                  CHGVAR     VAR(&FILE) VALUE(FFTRX2PD)                                   /*CER001*/
                  CHGVAR     VAR(&MEMBER) VALUE(OTC)
                  GOTO       CMDLBL(MISM)
                  ENDDO
 
/***  Setup OTC member   ***/
 
        OVRDBF     FILE(TRANSD)  MBR(OTC)
/**********OVRDBF     FILE(TRANSDX6)  MBR(OTC)                                            /*CER001*/
        OVRDBF     FILE(FFTRX2PD)  MBR(OTC)                                               /*CER001*/
        CALL       PGM(FF0020X6) PARM(&PRTCD &PMOD)
        DLTOVR     FILE(TRANSD)
/**********DLTOVR     FILE(TRANSDX6)                                                      /*CER001*/
        DLTOVR     FILE(FFTRX2PD)                                                         /*CER001*/
 
/* Loop to Process All Market Centres (in MARKTD)                   */
 
 LOOP1:      RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
/*** setup not deleted market center  ***/
 
             IF         COND(&RECI *NE '*') THEN(DO)
                  CHGVAR     VAR(&MKT) VALUE(&MRKT)
/**********       CHKOBJ     OBJ(TRANSDX6) OBJTYPE(*FILE) MBR(&MKT)                       /*CER001*/
                  CHKOBJ     OBJ(FFTRX2PD) OBJTYPE(*FILE) MBR(&MKT)                       /*CER001*/
                  MONMSG     MSGID(CPF9815) EXEC(DO)  /*** not found, add it ***/
/**********           ADDPFM     FILE(TRANSDX6) MBR(&MKT)                                 /*CER001*/
/**********           ADDLFM     FILE(TRANSDY6) MBR(&MKT) DTAMBRS((TRANSDX6 +             /*CER001*/
                      ADDPFM     FILE(FFTRX2PD) MBR(&MKT)                                 /*CER001*/
                      ADDLFM     FILE(FFTRX2L0) MBR(&MKT) DTAMBRS((FFTRX2PD +
                                (&MKT)))
                      ENDDO
 
/***  Setup Market member  ***/
 
                  OVRDBF     FILE(TRANSD)  MBR(&MKT)
/**********       OVRDBF     FILE(TRANSDX6)  MBR(&MKT)                                    /*CER001*/
                  OVRDBF     FILE(FFTRX2PD)  MBR(&MKT)                                    /*CER001*/
                  CALL       PGM(FF0020X6) PARM(&PRTCD &PMOD)
                  DLTOVR     FILE(TRANSD)
/**********       DLTOVR     FILE(TRANSDX6)                                               /*CER001*/
                  DLTOVR     FILE(FFTRX2PD)                                               /*CER001*/
                  ENDDO
 
/***  Read next Market  ***/
 
             GOTO       CMDLBL(LOOP1)
 
 MISM:       SNDPGMMSG  MSG('Program FFC0020X6 ended abnormally, +
                          missing *File ' *CAT &FILE *BCAT +
                          '*Member' *BCAT &MEMBER) TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             GOTO       CMDLBL(END)
 
 ABNOR:
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          FFC0020X6 ended abnormally - see job +
                          log') TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2005')
 
             ENDPGM
