/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE FRENCH TICKET D'AGIOS')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas     Retail Module                                 */
/*                                                                   */
/*       REC3764 - INTEREST STMT PRINT - TICKET D'AGIO               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCLF       FILE(TABTBRE)
             RCVF       RCDFMT(TABTBREF)
             IF         COND(&TAIA *EQ 'Y') THEN(DO)
/**/
             SNDPGMMSG  MSG('REC3764 - Tickect d''agio') TOMSGQ(MRUNQ)
/**/
/*/COPY WNCPYSRC,REC3764001                                          */
             CALL       PGM(RE3764)
/*/COPY WNCPYSRC,REC3764002                                          */
             ENDDO
             ELSE DO
             SNDPGMMSG  MSG('No records to process by RE3764') +
                          TOMSGQ(MRUNQ)
                          ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDCL:       ENDPGM
