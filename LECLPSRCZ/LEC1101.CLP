/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE YEAR END RECREATE FILE')                     */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*                LEC1101 - YEAR-END RECREATE FILE                  */
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
/*       Prev Amend No. S01179             Date 14/09/88             */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*    S01179 - AS400 INCORPORATION                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/************DCLDTAARA  DTAARA(LESTAT)                              *  *S01179*/
             DCL VAR(&LESTAT) TYPE(*CHAR) LEN(256)
/**/
             SNDPGMMSG  MSG('RECREATE YEAR-TO-DATE FILE') +
                        TOMSGQ(MRUNQ)
/**/
             RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)
/**/
             IF         COND(%SUBSTRING(&LESTAT 14 1) *EQ 'Y') THEN(DO)
                CLRPFM     FILE(LEYTDHH)
                CLRPFM     FILE(LEYTDYT)
                CLRPFM     FILE(LEYTDZZ)
/**/
                CALL       PGM(LE1050)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
