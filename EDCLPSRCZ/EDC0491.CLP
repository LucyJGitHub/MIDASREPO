/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED MKCTLD/PRISCD special processing (i/c)')     */
/********************************************************************/
/*                                                                  */
/*       Midas - Export Data Interface Module                       */
/*                                                                  */
/*       EDC0491 - MKCTLD/PRICSD Special Processing                 */
/*                                                                  */
/*       Function : This program is part of the special processing  */
/*                  for the market control file. It obtains the     */
/*                  journal sequence no. for the beginning of       */
/*                  the End of Centre process. Calling ED0491 to    */
/*                  extract all changes to PRICSD and write them    */
/*                  to PF/EDJRNEPD.                                 */
/*                                                                  */
/*       Calls :    ED0491                                          */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. CED005 *CREATE     DATE 23JUL97             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/*       CED005 - Midas ED Enhancements                             */
/*                                                                  */
/********************************************************************/
 
             PGM        PARM(&DATA1 &DATA2 &SRCF &CDFILE &CDBKEY +
                          &WRTCD &RECCNT &MKTC)
 
 
/* Copyright statement definition */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&DATA1) TYPE(*CHAR) LEN(125)
             DCL        VAR(&DATA2) TYPE(*CHAR) LEN(3971)
             DCL        VAR(&SRCF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CDFILE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CDBKEY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WRTCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RECCNT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&MKTC) TYPE(*CHAR) LEN(2)
 
 
/* Global error monitor */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
/* Copyright statement definition - at runtime */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/* Display journal entries written by Future and Options Module     */
/* to EDBFRJPD   */
             DSPJRN     JRN(ICJRN) RCVRNG(*CURCHAIN) ENTTYP(FC) +
                          OUTPUT(*OUTFILE) OUTFILE(EDBFRJPD)
 
/* Call ED0491 to obtain changes to PRICSD and write them to drip   */
/* feed file EDJRNEPD   */
             CALL       PGM(ED0491) PARM(&DATA1 &DATA2 &SRCF &CDFILE +
                          &CDBKEY &WRTCD &RECCNT &MKTC)
 
 
/* Normal termination */
FINAL:
             IF         COND(&WRTCD = ' ') THEN(GOTO CMDLBL(ENDCLPGM))
             ELSE       CMD(GOTO CMDLBL(ABNOR))
 
 
/* Abnormal termination */
ABNOR:
 
 
             SNDPGMMSG  MSG('EDC0491 - ED Market Control Special +
                          Processing TERMINATED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CHGJOB     SWS(XXXXXX11)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
ENDCLPGM:
             ENDPGM
