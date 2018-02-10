/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Periodic Drop of Management Accts')          */
/*OVR  : OVRDBF FILE(MEMLIST) TOFILE(QAFDMBRL)                      :*/
/*********************************************************************/
/*                                                                   */
/*   Midas - Management Accounts Module                              */
/*                                                                   */
/*   MCC0270 - Periodic drop of Management Accounts                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 228542             Date 10Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      XXXXXX             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       228542 - RGZPFM has changed at R5V3                         */
/*                                                                   */
/*********************************************************************/
 
/*   Job switch use                                                  */
 
/*   U1 - Records have been deleted, so reorganise physical files    */
/*   U7 - Database error                                             */
/*   U8 - Database error                                             */
 
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50) VALUE('Error +
                          message variable')
             DCL        VAR(&CHKPOSN) TYPE(*DEC) LEN(2 0) VALUE(10)                       /*228542*/
             DCL        VAR(&LAST) TYPE(*CHAR) LEN(1)                                     /*228542*/
             DCL        VAR(&NAMECHK) TYPE(*CHAR) LEN(10)                                 /*228542*/
 
             DCLF       FILE(QTEMP/MEMLIST) /* File to receive +
                          list of members */
 
/* Global error message                                              */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* Create local data area                                            */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')
             MONMSG     MSGID(CPF1023) /* LDA already exists */
 
/* Reset job switches U1, U7, U8                                     */
             CHGJOB     SWS(0XXXXX00)
 
/* Call the Periodic drop program                                    */
             CALL       PGM(MC0270)
 
/* Check for database error                                          */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ENDPGM)
             ENDDO      /* End of database error section */
 
/* If *INU1 is on, then records have been deleted                    */
             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
 
/* Reorganise Historic balances file to remove deleted records   */
 
/* Dump list of members into work file in QTEMP                      */
             DSPFD      FILE(*LIBL/GLHIBLPD) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/MEMLIST) OUTMBR(*FIRST +
                          *REPLACE)
 
/* Reorganise Average balances file to remove deleted records    */
 
/* Dump list of members into work file in QTEMP, too.                */
             DSPFD      FILE(*LIBL/GLAVBLPD) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/MEMLIST) OUTMBR(*FIRST +
                          *ADD)
 
 
/* Read through list and reorganise each member in turn              */
 
 TAG1:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM)) /* +
                          end of file */
                                                                                          /*228542*/
/* Pad variable with blanks */                                                            /*228542*/
                                                                                          /*228542*/
             CHGVAR     VAR(&NAMECHK) VALUE(&MLNAME)                                      /*228542*/
                                                                                          /*228542*/
 BLANKCHK:                                                                                /*228542*/
             CHGVAR     VAR(&LAST) VALUE(%SST(&NAMECHK &CHKPOSN 1))                       /*228542*/
                                                                                          /*228542*/
             IF         COND(&LAST *EQ ' ') THEN(DO)                                      /*228542*/
                CHGVAR     VAR(%SST(&NAMECHK &CHKPOSN 1)) +
                             VALUE('*')                                                   /*228542*/
                CHGVAR     VAR(&CHKPOSN) VALUE(&CHKPOSN - 1)                              /*228542*/
                GOTO       CMDLBL(BLANKCHK)                                               /*228542*/
             ENDDO                                                                        /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(&MLFILE) MBR(&MLNAME)                                        /*228542*/
/**********  MONMSG     MSGID(CPF2981) /* Member not reorganised */                       /*228542*/
             CALL       PGM(SCC000060) PARM(&MLFILE &NAMECHK)                             /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
             GOTO       CMDLBL(TAG1)
 
             ENDDO      /* End of section run if *INU1 is seton */
 
/* Reorganise Group codes file                                       */
/**********  RGZPFM     FILE(GLHBCGPD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2981) /* empty file */                                   /*228542*/
             CALL       PGM(SCC000060) PARM('GLHBCGPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
 
             GOTO       CMDLBL(ENDPGM)
 
 ERROR:      SNDPGMMSG  MSG('Periodic drop of Management Accounts +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
ENDPGM: ENDPGM
