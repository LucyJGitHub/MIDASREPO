/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED Drip feed delete batch')                     */
/********************************************************************/
/*                                                                  */
/*       Midas - Midas Export Data Module                           */
/*                                                                  */
/*       EDC0070 - Drip Feed Delete a Batch                         */
/*                                                                  */
/*       Function : This program receives parameter PBTCH (batch to */
/*                  be processed) and removes the member with the   */
/*                  same name.                                      */
/*                                                                  */
/********Called*by*:*ED0080*-*Drip*Feed*Determine*Deletions         * /*101971*/
/*       Called by : ED0101 - Drip Feed Determine Deletions         * /*101971*/
/*                                                                  */
/*       Calls :     None                                           */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 113682             Date 04Feb98              */
/*                      101971             Date 17Jul95              */
/*                      S01493 *CREATE     DATE 16MAY94             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       113682 - Error messages should be sent to MOPERQ not       */
/*                QSYSOPR.                                          */
/*       101971 - Phase II Modifications                            */
/*       S01493 - Midas Export Data Module                          */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&PBTCH &PRTN)
 
/* Copyright statement definition */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&PBTCH) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTN) TYPE(*CHAR) LEN(1)
 
/* Global error monitor */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Remove the member */
 
             RMVM       FILE(EDJRNEPD) MBR(&PBTCH)
             MONMSG     MSGID(CPF5815 CPF7310)
 
             GOTO       CMDLBL(ENDCLPGM)
 
/* Copyright statement definition - at runtime */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
ABNOR:
/*113682*****SNDPGMMSG  MSG('EDC0070 ED Drip Feed Delete a +
                          Batch TERMINATED ABNORMALLY') +
                          TOMSGQ(*SYSOPR) MSGTYPE(*INQ)              /*113682*/
             SNDPGMMSG  MSG('EDC0070 ED Drip Feed Delete a +
                          Batch TERMINATED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)                       /*113682*/
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&PRTN) VALUE('Y')
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
               CHGJOB     SWS(XXXXXX11)
               MONMSG     MSGID(CPF0000 MCH0000)
               DMPCLPGM
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
ENDCLPGM:
             ENDPGM
