/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Redreate loans and guars xref')              */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC0902 - RECREATE LOANS AND GUARANTEES REFERENCE FILES    */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01194              DATE  07FEB90           */
/*                                                                  */
/********************************************************************/
/*       S01194 - NEW STANDING DATA                                 */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*/COPY WNCPYSRC,LEC0902003                                          */
/**/
             SNDPGMMSG  MSG('RECREATE LOANS AND GUARANTEES REFERENCE +
                             FILES') TOMSGQ(MRUNQ)
/**/
             CLRPFM     FILE(LEREFD1)
/**/
/************OVRDBF     FILE(TABLE) TOFILE(TABLEEE)        */         /*S01194*/
             CALL       PGM(LE0830)
/*/COPY WNCPYSRC,LEC0902001                                          */
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
                CLRPFM     FILE(GTREFHG)
                CLRPFM     FILE(GTREFGR)
                CALL       PGM(LE0831)
/*/COPY WNCPYSRC,LEC0902002                                          */
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
