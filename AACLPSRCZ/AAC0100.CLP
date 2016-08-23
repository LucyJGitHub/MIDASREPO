/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AA Analyis of a/c postings profit centres')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Analytical Accounting Module                        */
/*                                                                   */
/*       AAC0100 - Analysis of Account Postings Profit Centre        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CAC001 *CREATE     Date 01FEB96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CAC001 - Profit Centre Accounting Development:              */
/*                New CL program.                                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SELPC &OMTPC &SHWON &INCRN)
 
             DCL        VAR(&SELPC) TYPE(*CHAR) LEN(4)
             DCL        VAR(&OMTPC) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SHWON) TYPE(*CHAR) LEN(1)
             DCL        VAR(&INCRN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&QRYSL) TYPE(*CHAR) LEN(20)
             DCL        VAR(&TXT1) TYPE(*CHAR) LEN(10) +
                          VALUE('*ALL      ')
             DCL        VAR(&TXT2) TYPE(*CHAR) LEN(10) VALUE('PRFC +
                          *EQ "')
             DCL        VAR(&TXT3) TYPE(*CHAR) LEN(10) VALUE('PRFC +
                          *NE "')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             IF         COND(&SELPC *EQ '*ALL')  THEN(DO)
             CHGVAR     VAR(&QRYSL) VALUE(&TXT1)
             ENDDO
 
             IF         COND(&SELPC *NE '*ALL')  THEN(DO)
             CHGVAR     VAR(&QRYSL) VALUE(&TXT2 *CAT &SELPC *CAT '"')
             ENDDO
 
             IF         COND(&OMTPC *NE '    ')  THEN(DO)
             CHGVAR     VAR(&QRYSL) VALUE(&TXT3 *CAT &OMTPC *CAT '"')
             ENDDO
 
             OVRDBF     FILE(AAACPS) TOFILE(GLOPBLPD) SHARE(*YES)
 
             OPNQRYF    FILE((GLOPBLPD) (QTEMP/GLPOSTX)) +
                          FORMAT(AAACPS) +
                           QRYSLT(&QRYSL) +
                           KEYFLD((BRCA)  +
                                  (CCY )  +
                                  (CNUM)  +
                                  (ACOD)  +
                                  (ACSQ)  +
                                  (PRFC)  +
                                  (SPOS)  +
                                  (OTTP)  +
                                  (OTST)  +
                                  (OTRF)  +
                                  (PNAR)  +
                                  (BOKC)) +
                          JFLD(  (GLPOSTX/BRCA GLOPBLPD/BRCA) +
                                 (GLPOSTX/CCY  GLOPBLPD/CCY )   +
                                 (GLPOSTX/ACOD GLOPBLPD/ACOD)   +
                                 (GLPOSTX/CNUM GLOPBLPD/CNUM)   +
                                 (GLPOSTX/ACSQ GLOPBLPD/ACSQ))  +
                      MAPFLD(  (BRCA     'GLOPBLPD/BRCA') +
                               (CCY      'GLOPBLPD/CCY ') +
                               (ACOD     'GLOPBLPD/ACOD') +
                               (CNUM     'GLOPBLPD/CNUM') +
                               (ACSQ     'GLOPBLPD/ACSQ') +
                               (PRFC     'GLPOSTX/PRFC') +
                               (BOKC     'GLPOSTX/BOKC') +
                               (OTTP     'GLPOSTX/OTTP') +
                               (OTST     'GLPOSTX/OTST') +
                               (ASOC     'GLPOSTX/ASOC') )  +
                      JDFTVAL(*YES)
 
            CHGJOB SWS(00000000)
 
             IF         COND(&SHWON *EQ 'Y') THEN(CHGJOB SWS(1XXXXXXX))
             IF         COND(&INCRN *EQ 'Y') THEN(CHGJOB SWS(X1XXXXXX))
 
            CALL AA0100
 
            CLOF GLOPBLPD
            DLTOVR AAACPS
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
