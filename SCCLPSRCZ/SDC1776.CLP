/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Rep last sucs. trans on primy m/c')          */
/********************************************************************/
/*                                                                  */
/*        Midas - System Control Module                     */
/*                                                                  */
/*       SDC1776 - Update SD1724 file with unique key & accpth data */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408             DATE 10MAY95              */
/*       PREV AMEND NO. E29436             DATE  11OCT91            */
/*                      E24370             DATE  19JUL91            */
/*                      S01337             DATE  17APR91            */
/*                      E13205             DATE  14/02/89           */
/*                                                                  */
/********************************************************************/
/*       New program overview                                       */
/*                                                                  */
/*       S01408 - Addition of core hook SDC1776MPS                  */
/*       E29436 - MOVE TO SCCLSRC FROM RR.                          */
/*       E24370 - PF/ACCPTH WAS CREATED ALLOWING ONLY 13000 RCDS    */
/*                WHICH IS SOMETIMES NOT ENOUGH. FILE CREATED THEN  */
/*                CHANGED TO SIZE(*NOMAX).                          */
/*       S01337 - SPLIT 'D' LIBRARY INTO 'DP' AND 'DV' LIBRARIES    */
/*       E13205 - Display key data for all files in the DLIB        */
/*                and for all unique keys call SD1731               */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*           Declare variables                                       */
/**/
/**********  DCL        VAR(&DLIB) TYPE(*CHAR) LEN(10)                 *S01337*/
             DCL        VAR(&DVLIB) TYPE(*CHAR) LEN(10)               /*S01337*/
             DCL        VAR(&LAST_FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
/**/
             DCLF       FILE(*LIBL/QAFDACCP)
/**/
/*           Global Monitor message                                  */
/**/
             MONMSG     MSGID(MCH0000 CPF0000) EXEC(GOTO CMDLBL(ABNOR))
/**/
             RTVDTAARA  DTAARA(*LIBL/SDSTAT (6 2)) RTNVAR(&DBPREFIX)
/************CHGVAR     VAR(&DLIB) VALUE(&DBPREFIX *CAT 'DLIB')         S01337*/
             CHGVAR     VAR(&DVLIB) VALUE(&DBPREFIX *CAT 'DVLIB')     /*S01337*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1776MPS                                          */
                                                                      /*S01408*/
/**/                                                                  /*E24370*/
/*  Create PF/ACCPTH and change object to allow unlimited records  */ /*E24370*/
/**/                                                                  /*E24370*/
             DSPFD      FILE(&DVLIB/SDMMODL1) TYPE(*ACCPTH) +
                          OUTPUT(*OUTFILE) FILEATR(*LF) +
                          OUTFILE(QTEMP/ACCPTH)                       /*E24370*/
                                                                      /*E24370*/
             CHGPF      FILE(QTEMP/ACCPTH) SIZE(*NOMAX)               /*E42370*/
                                                                      /*E24370*/
/**/
/*           Display all key information to ACCPTH.QTEMP             */
/**/
/************DSPFD      FILE(&DLIB/*ALL) TYPE(*ACCPTH) +
/************             OUTPUT(*OUTFILE) OUTFILE(QTEMP/ACCPTH) +
/************             FILEATR(*LF)                                /*S01337*/
             DSPFD      FILE(&DVLIB/*ALL) TYPE(*ACCPTH) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/ACCPTH) +
                          FILEATR(*LF)                                /*S01337*/
/**/
/*           Read until end of file                                  */
/**/
             OVRDBF     FILE(QAFDACCP) TOFILE(QTEMP/ACCPTH)
 READ:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
/**/
/*           Only use information on first record for each file      */
/**/
             IF         COND(&LAST_FILE *EQ &APFILE) THEN(GOTO +
                          CMDLBL(READ))
/**/
/*           If unique key call SD1731                               */
/**/
             IF         COND(&APUNIQ *EQ 'Y') THEN(DO)
             CALL       PGM(*LIBL/SD1731) PARM('*UNIQUE' &APFILE +
                          &APLIB ' ' &RTNCDE)
             ENDDO
             ELSE       CMD(DO)
             IF         COND((&APMANT *EQ 'R') +
                        *OR  (&APMANT *EQ 'D')) THEN(DO)
             CALL       PGM(*LIBL/SD1731) PARM('*NOTIMD' &APFILE +
                          &APLIB ' ' &RTNCDE)
             ENDDO
             ELSE       CMD(DO)
             CALL       PGM(*LIBL/SD1731) PARM('*IMMED ' &APFILE +
                          &APLIB ' ' &RTNCDE)
             ENDDO
             ENDDO
             IF         COND(&RTNCDE *EQ '*ERROR') THEN(GOTO +
                          CMDLBL(ABNOR))
/**/
             CHGVAR     VAR(&LAST_FILE) VALUE(&APFILE)
/**/
             GOTO       CMDLBL(READ)
/**/
             GOTO       CMDLBL(END)
/**/
 ABNOR:      SNDPGMMSG  MSG('PROGRAM SDC1776 - Update SD1724 with +
                          unique key & accpth data - ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(*LIBL/MOPERQ *LIBL/MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
