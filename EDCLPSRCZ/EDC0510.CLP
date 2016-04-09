/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED Copy of DKEYSDP')                            */
/********************************************************************/
/*                                                                  */
/*       Midas - Export Data Interface Module                       */
/*                                                                  */
/*       EDC0510 -  Copy of DKEYSDP                                 */
/*                                                                  */
/*       Function : This program copies selected a/c key records    */
/*                  from DKEYSDP to the ED Extract file EDDKEYDP.   */
/*                  A/c key records are copied if they match one    */
/*                  of the a/c key 'Skeletons' in EDDKYRPD.         */
/*                                                                  */
/*       Called By: CBC0050  Midas Close of Business component      */
/*                                                                  */
/*       Calls :    *None                                           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. CED006 *CREATE     DATE 22JUL97             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CED006 - Midas ED Enhancements                             */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&CNAM &CSEQ &MBRN)
 
/* Copyright statement definition */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&MBRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
 
/* Global error monitor */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             CHGJOB     SWS(00000000)
 
/* Call AOBUTFR0 to check file EDDKEYPD selected for transfer to GM */
 
             CALL       PGM(AOBUTFR0) PARM('EDDKEYPD' '         ' +
                          &RTCD &FMT)
 
/* EDDKEYPD is selected for transfer */
 
             IF         COND(&RTCD *NE '*FAILED') THEN(DO)
 
/* Select matching a/c key records */
             OPNQRYF    FILE((DKEYSDP) (EDDKYRPD) (SDBANKPD)) +
                          FORMAT(EDDKEYPD EDDKEYD0) JFLD((AKEYE3 +
                          AKEYR3 *EQ) (AKEYE6 AKEYR6) (AKEYE9 +
                          AKEYR9) (AKEYE10 AKEYR10)) MAPFLD((AKEYE3 +
                          '%SST(DKEYSDP/AKEY 3 1)') (AKEYR3 +
                          '%SST(EDDKYRPD/FYAKEY 3 1)') (AKEYE6 +
                          '%SST(DKEYSDP/AKEY 6 1)') (AKEYR6 +
                          '%SST(EDDKYRPD/FYAKEY 6 1)') (AKEYE9 +
                          '%SST(DKEYSDP/AKEY 9 1)') (AKEYR9 +
                          '%SST(EDDKYRPD/FYAKEY 9 1)') (AKEYE10 +
                          '%SST(DKEYSDP/AKEY 10 1)') (AKEYR10 +
                          '%SST(EDDKYRPD/FYAKEY 10 1)') (AGRDNB +
                          'SDBANKPD/BJRDNB')) OPNID(EDDKEYPD)
 
               CPYFRMQRYF FROMOPNID(EDDKEYPD) TOFILE(EDDKEYPD) +
                          TOMBR(&MBRN) MBROPT(*REPLACE)
/* Close */
             CLOF       OPNID(EDDKEYPD)
             ENDDO
 
/* Normal termination */
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(ENDCLPGM))
 
 
/* Abnormal termination */
ABNOR:
             SNDPGMMSG  MSG('EDC0510 - ED Copy of DKEYSDP TERMINATED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CHGJOB     SWS(XXXXXX11)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
