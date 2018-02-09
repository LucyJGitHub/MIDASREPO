/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Purge Historic Control Records')             */
/*********************************************************************/
/*                                                                   */
/*       Midas General Ledger Module                             */
/*                                                                   */
/*       GLC4455 - Purge Historic Control Records                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 228542             Date 05Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      096747             Date 09Jul96              */
/*                      S01408             Date 20Jun95              */
/*                      S01520 *CREATE     DATE 02NOV94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       096747 - Change Reorganise process to make more efficient.  */
/*       S01408 - Addition of core hook GLC4455MP1                   */
/*       S01520 - BLI Account Statements Changes                     */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)
 
/**/
 
             SNDPGMMSG  MSG('GLC4455 - Purge Historic Control +
                          Records') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXXX00)
 
/**/
/*   Call PGM CB0160 , to find out the value of Busy              */
/**/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &BUSY)
/**/
/* SETUP SECURITY COPY LIBRARY NAME */
/**/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *CAT 'DPLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB')
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC4455MP1                                     */    /*S01408*/
/**/                                                                  /*S01408*/
 
/**/
/* IF THIS IS NOT A RESTART THEN CREATE SECURITY COPY */
/**/
 
             IF         COND(&BUSY *EQ 'N') THEN(DO)
                  DLTF       FILE(&DPLIB/XCPOSTDD)
                             MONMSG     MSGID(CPF0000)
                  CPYF       FROMFILE(&DMLIB/CPOSTDD) +
                               TOFILE(&DPLIB/XCPOSTDD) +
                               MBROPT(*REPLACE) CRTFILE(*YES)
                             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
                  CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'Y')
            ENDDO
 
            ELSE       CMD(DO)
/**/
/* IF THIS IS A RESTART THEN COPY SECURITY COPY BACK TO MASTER FILE */
/**/
 
                  CPYF       FROMFILE(&DPLIB/XCPOSTDD) TOFILE+
                               (&DMLIB/CPOSTDD) MBROPT(*REPLACE)
                             MONMSG    MSGID(CPF2817) CMPDTA(CPF2869) +
                               EXEC(CLRPFM FILE(&DMLIB/CPOSTDD))
            ENDDO
 
/**/
/* CALL PURGE HISTORIC CONTROL RECORDS PROGRAM */
/**/
 
 
             CALL       PGM(GL4455)
             IF COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/* IF PURGE IS SUCCESSFUL THEN REORGANIZE MASTER FILE */
/**/
/****************CPYF       FROMFILE(&DMLIB/CPOSTDD) +                  096747*/
/****************             TOFILE(QTEMP/CPOSTDD) MBROPT(*REPLACE) +  096747*/
/****************             CRTFILE(*YES)                             096747*/
/****************           MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)   096747*/
/****************RGZPFM     FILE(QTEMP/CPOSTDD)                         096747*/
/****************           MONMSG     MSGID(CPF2981)                   096747*/
/****************CPYF       FROMFILE(QTEMP/CPOSTDD) +                   096747*/
/****************            TOFILE(&DMLIB/CPOSTDD) MBROPT(*REPLACE) +  096747*/
/****************            CRTFILE(*NO)                               096747*/
/****************           MONMSG    MSGID(CPF2817) CMPDTA(CPF2869) +  096747*/
/****************             EXEC(CLRPFM FILE(&DMLIB/CPOSTDD))         096747*/
/****************                                                       096747*/
             RMVM       FILE(CPOST) MBR(CPOST)                        /*096747*/
             MONMSG     MSGID(CPF0000)                                /*096747*/
/**********  RGZPFM     FILE(CPOSTDD)                                 /*096747*/          /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                /*096747*/          /*228542*/
             CALL       PGM(SCC000060) PARM('CPOSTDD' '*FIRST')                           /*228542*/
                                                                                          /*228542*/
             ADDLFM     FILE(CPOST) MBR(CPOST) SHARE(*YES)            /*096747*/
             MONMSG     MSGID(CPF0000)                                /*096747*/
/**/
/* SET OFF THE BUSY FLAG */
/**/
 
                 CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'N')
                 DLTF       FILE(&DPLIB/XCPOSTDD)
                 MONMSG     MSGID(CPF0000)
             ENDDO
 
             ELSE       CMD(DO)
/**/
/* DATABASE ERROR ROUTINE */
/**/
 
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
/**/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
