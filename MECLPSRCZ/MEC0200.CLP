/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME Drop historic messages')                     */
/********************************************************************/
/*                                                                  */
/*       Midas     - MESSAGE MANAGEMENT                             */
/*                                                                  */
/*       MEC0200 - Drop historic messages                           */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 228542             Date 10Aug04              */
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      183583             Date 27Jun01              */
/*                      171060             Date 27Feb01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      190127             Date 28Feb01             */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CDL008             Date 02May00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                       CMT001            Date 06Feb99              */
/*                       078777           DATE 27JAN98              */
/*                       101137           DATE 29MAY96              */
/*                       066991           DATE 01NOV94              */
/*                       E33134           DATE 10DEC91              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       183583 - Add processing for extension file backup.          */
/*       171060 - Remove dropping of CFFEEDPD records as this        */
/*                is done by CF0070. Applied fix 148906.             */
/*   190127  -  Related reference should contain tansaction         */
/*              reference of previous message of same type          */
/*   CDL008 -   Continuous Linked Settlement (Recompiled MGOREFPD)  */
/*   CMT001  -  Telex upgrade to Midas Mailer (Telex 3.3).          */
/*              Call MT0201 instead of MT0200.                      */
/*   078777  -  Add housekeeping processing for CFCHSRPD Conf'n     */
/*              Chaser and CFFEEDPD TRAM Feedback files.            */
/*   101137  -  Only call MT0200 if the Telex module has been       */
/*              switched on. (drop hist msgs - Midas/Orion i/f file)*/
/*   066991  -  Orion not passing Telex status back to Midas        */
/*   E33134  -  MONITOR FOR CPF2869 TO PREVENT PROGRAM CRASHING     */
/*              WHEN IT TRIES TO COPY AN EMPTY FILE                 */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1) VALUE(' ')      /*066991*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('CMT001') /*CMT001*/
             DCL        VAR(&RETCOD) TYPE(*CHAR) LEN(7) VALUE(' ')    /*101137*/
             DCL       VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ') /*101137*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*101137*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,MEC0200003                                          */
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERR)
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('Message Management - Drop historic +
                          messages') TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,MEC0200007                                          */
 
/* Set-off Data Base Error Switches. */
             CHGJOB     SWS(XXXXXX00)
 
/*  Access PF/SDMMODPD to determine which modules are live  */        /*101137*/
/**/                                                                  /*101137*/
             CALL       PGM(AOMMODR0) PARM(&RETCOD &OPTN &FMT)        /*101137*/
/**/                                                                  /*101137*/
/** Database error handling */                                        /*101137*/
/**/                                                                  /*101137*/
             IF         COND(&RETCOD *NE '       ') THEN(DO)          /*101137*/
             SNDPGMMSG  MSG('Error on access to ICD file AOMMODPD') +
                          TOMSGQ(MOPERQ)                              /*101137*/
             GOTO       CMDLBL(END)                                   /*101137*/
             ENDDO                                                    /*101137*/
 
/* Clear Outgoing Message backup files */
             CLRPFM     FILE(MGOREFBK)
             CLRPFM     FILE(MGOMSGBK)
             CLRPFM     FILE(MGOEXTBK)                                /*183583*/
/*/COPY WNCPYSRC,MEC0200004                                          */
                                                                      /*078777*/
/* Clear Conf Chaser and TRAM Feedback backup files */                /*078777*/
             CLRPFM     FILE(CFCHSRBK)                                /*078777*/
/**********  CLRPFM     FILE(CFFEEDBK) */                                          /*078777 171060*/
                                                                      /*078777*/
/*/COPY WNCPYSRC,MEC0200001                                          */
 
/* Call MEC0200 (Drop historic messages) */
/**********  CALL PGM(ME0200) */                                      /*066991*/
             CALL       PGM(ME0200) PARM(&RTCD)                       /*066991*/
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ.                                                        */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
                 GOTO END
             ENDDO
 
/*/COPY WNCPYSRC,MEC0200005                                          */
/* Reorganize Midas-Orion interface file if Telex records to delete   /*066991*/
 
/* If Telex module is Switched On.                                    /*101137*/
             IF         COND(%SST(&FMT 15 1) *EQ 'Y') THEN(DO)        /*101137*/
             IF         COND(&RTCD *EQ 'Y') THEN(DO)                  /*066991*/
/************CALL       PGM(MT0200) */                         /*066991 CMT001*/
/**/                                                                  /*CMT001*/
/** Check if Midas Mailer is installed. */                            /*CMT001*/
/**/                                                                  /*CMT001*/
             CHGVAR VAR(&RETCOD) VALUE('       ')                     /*CMT001*/
             CHGVAR VAR(&OPTN)   VALUE('*VERIFY')                     /*CMT001*/
                                                                      /*CMT001*/
             CALL   PGM(AOSARDR0) PARM(&RETCOD &OPTN &SARD &FMT)      /*CMT001*/
/**/                                                                  /*CMT001*/
/** If installed, call MT0201, otherwise call MT0200. */              /*CMT001*/
/**/                                                                  /*CMT001*/
             IF     COND(&RETCOD *EQ '       ') +
                        THEN(CALL PGM(MT0201))                        /*CMT001*/
/**/                                                                  /*CMT001*/
                    ELSE CMD(CALL PGM(MT0200))                        /*CMT001*/
/**/                                                                  /*CMT001*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*066991*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*066991*/
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)                          /*066991*/
                 GOTO       CMDLBL(END)                               /*066991*/
             ENDDO                                                    /*066991*/
/**********  RGZPFM     FILE(N#MO)                                    /*066991*/          /*228542*/
/**********  MONMSG     MSGID(CPF0000)                                /*066991*/          /*228542*/
             CALL       PGM(SCC000060) PARM('N#MO' '*FIRST')                              /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERR))                                                    /*228542*/
                                                                                          /*228542*/
             ENDDO                                                    /*066991*/
             ENDDO                                                    /*101137*/
 
/* Copy from back up file to MGOREFPD */
             CPYF     FROMFILE(MGOREFBK) TOFILE(*LIBL/MGOREFPD) +
                          MBROPT(*REPLACE) CRTFILE(*NO)
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) */      /*E33134 183583*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MGOREFPD))                             /*183583*/
 
/* Copy from back up file to MGOMSGPD */
             CPYF     FROMFILE(MGOMSGBK) TOFILE(*LIBL/MGOMSGPD) +
                          MBROPT(*REPLACE) CRTFILE(*NO)
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) */      /*E33134 183583*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MGOMSGPD))                             /*183583*/
                                                                      /*183583*/
/** Copy from back up file to MGOEXTPD */                             /*183583*/
             CPYF       FROMFILE(MGOEXTBK) TOFILE(*LIBL/MGOEXTPD) +
                          MBROPT(*REPLACE) CRTFILE(*NO)               /*183583*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MGOEXTPD))                             /*183583*/
                                                                      /*078777*/
/*/COPY WNCPYSRC,MEC0200006                                          */
/* Copy from back up file to CFCHSRPD */                              /*078777*/
             CPYF     FROMFILE(CFCHSRBK) TOFILE(*LIBL/CFCHSRPD) +
                          MBROPT(*REPLACE) CRTFILE(*NO)               /*078777*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*078777*/
/* Copy from back up file to CFFEEDPD */
/**********  CPYF     FROMFILE(CFFEEDBK) TOFILE(*LIBL/CFFEEDPD) +
                          MBROPT(*REPLACE) CRTFILE(*NO)                            /*078777 171060*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                             /*078777 171060*/
                                                                      /*078777*/
/*/COPY WNCPYSRC,MEC0200002                                          */
                                                                      /*078777*/
             CALL       PGM(ME0250)                                   /*190127*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*190127*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*190127*/
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)                          /*190127*/
                 GOTO       CMDLBL(END)                               /*190127*/
             ENDDO                                                    /*190127*/
/*/COPY WNCPYSRC,MEC0200008                                          */
                                                                      /*078777*/
             GOTO END
 
 ERR:        SNDPGMMSG  MSG('Message Management - Drop Historic +
                          Messages ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
             CHGJOB SWS(XXXXXX11)
             MONMSG MSGID(CPF0000 MCH0000)
 
 END:        RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
