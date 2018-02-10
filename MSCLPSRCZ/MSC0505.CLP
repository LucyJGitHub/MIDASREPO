/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MS I/c term file deletion')                     */
/*********************************************************************/
/*                                                                   */
/*     Midas - SWIFT DIRECT LINK                                     */
/*                                                                   */
/*     MSC0505 - I/C TERMINATION FILE CLEARANCE                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 120202             Date 11Jun97              */
/*                      CSW008             Date 21Oct96              */
/*                    S01408            DATE  04SEP96                */
/*                    S01310            DATE  06DEC90                */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*     120202 - AOMGMER0 parameters have changed                     */
/*     CSW008 - Midas/CAS interface.                                 */
/*              Clean up temporary files and data areas              */
/*     S01408 - ADDITION OF CORE HOOK MSC0505001                     */
/*     S01310 - RE WRITTEN FOR SWIFT RATIONALISATION                 */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CSW008*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST') /*CSW008*/
/************DCL        VAR(&MGME) TYPE(*CHAR) LEN(188)       *CSW008* *120202*/
             DCL        VAR(&MGME) TYPE(*CHAR) LEN(800)               /*120202*/
             DCL        VAR(&PFX) TYPE(*CHAR) LEN(2)                  /*CSW008*/
             DCL        VAR(&TFILES) TYPE(*CHAR) LEN(10)              /*CSW008*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*/COPY WNCPYSRC,MSC0505002                                          */
/* GLOBAL MONITOR MESSAGE */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
/* If protocol used is Common Application Server (CAS), clean up   */ /*CSW008*/
/* temporary files, data queues and data areas.                    */ /*CSW008*/
             CALL       PGM(AOMGMER0) PARM(&RTCD &OPTN &MGME)         /*CSW008*/
             IF         COND((%SST(&MGME 17 4)) *EQ 'CAS ') THEN(DO)  /*CSW008*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PFX)             /*CSW008*/
             CHGVAR     VAR(&TFILES) VALUE(&PFX *CAT '_TRACE')        /*CSW008*/
             DLTF       FILE(CASMF/&TFILES)                           /*CSW008*/
             MONMSG     MSGID(CPF0000)                                /*CSW008*/
             DLTDTAQ    DTAQ(MSQ*)                                    /*CSW008*/
             MONMSG     MSGID(CPF0000)                                /*CSW008*/
             DLTDTAARA  DTAARA(MCAS*)                                 /*CSW008*/
             MONMSG     MSGID(CPF0000)                                /*CSW008*/
             ENDDO                                                    /*CSW008*/
 
/* SET OFF EXTERNAL SWITCHES. */
             CHGJOB     SWS(00000000)
 
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MSC0505001                                                   */
                                                                      /*S01408*/
             CLRPFM MSIXI2BK
             CLRPFM MSMSI2BK
 
             CALL MS0505
 
/* DATABASE ERROR PROCESSING. SEND MESSAGE TO MOPERQ & WORKSTN */
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ) TOPGMQ(*EXT)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/* COPY REMAINING RECORDS BACK INTO THE MASTER FILES. */
             CLRPFM     MSIXI2PD
             CLRPFM     MSMSI2PD
 
             CPYF       FROMFILE(MSIXI2BK) TOFILE(MSIXI2PD) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(MSMSI2BK) TOFILE(MSMSI2PD) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CLRPFM     MS2780I
 
/*/COPY WNCPYSRC,MSC0505003                                          */
             GOTO ENDPGM
 ABNOR:      SNDPGMMSG  MSG('Input Cycle Termination ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXX1XXX)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
