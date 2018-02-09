/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Profitability Rpt by Fclty - Batch')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC47F - Profitability Report by Facility.                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. 253577             Date 28Mar08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      XXXXXX             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       253577 - Corrected expression used for Selection by         */
/*                Customer.                                          */
/*       XXXXXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RTYP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDAT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&USAC) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DEPT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&ACOF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CNUM) TYPE(*CHAR) LEN(6)
 
/* Read LERSTS Data Area to get Processing Date for Report  */
 
             RTVDTAARA  DTAARA(LERSTS (122 7)) RTNVAR(&PDAT)
 
/* Retrieve other parameters from &RPARM, set up by LER471 */
 
             CHGVAR     VAR(&USAC) VALUE(%SST(&RPARM 1 2))
             CHGVAR     VAR(&WSID) VALUE(%SST(&RPARM 3 12))
             CHGVAR     VAR(&RTYP) VALUE(%SST(&RPARM 13 1))
             IF         COND(&RTYP *EQ 'C') THEN(CHGVAR VAR(&CNUM) +
                          VALUE(%SST(&RPARM 14 6)))
             IF         COND(&RTYP *EQ 'A') THEN(CHGVAR VAR(&ACOF) +
                          VALUE(%SST(&RPARM 20 2)))
             IF         COND(&RTYP *EQ 'D') THEN(CHGVAR VAR(&DEPT) +
                          VALUE(%SST(&RPARM 22 3)))
 
/* Run OPNQRYF to select records to be reported  */
 
/* If Full Report requested, do not run OPNQRYF */
 
 IF    COND(&RTYP *NE 'T') THEN(DO)
 
      OVRDBF     FILE(LENQLF2)  SHARE(*YES)
 
/* Selection by Customer */
 
      IF         COND(&RTYP *EQ 'C') THEN(DO)
/**********OPNQRYF    FILE((LENQLF2 *FIRST LENQF)) QRYSLT(&CNUM +   */                    /*253577*/
/**********               *CAT ' *EQ NQCNUM') KEYFLD(*FILE)         */                    /*253577*/
             OPNQRYF    FILE((LENQLF2 *FIRST LENQF)) QRYSLT('NQCNUM +
                          *EQ ''' *CAT &CNUM *CAT '''') +
                          KEYFLD(*FILE)                                                   /*253577*/
      ENDDO
 
/* Selection by Account Officer */
 
      IF         COND(&RTYP *EQ 'A') THEN(DO)
           OPNQRYF    FILE((LENQLF2 *FIRST LENQF)) QRYSLT('NQACOF +
                          *eq  ''' *CAT &ACOF *CAT '''') KEYFLD(*FILE)
      ENDDO
 
/* Selection by Department */
 
      IF        COND(&RTYP *EQ 'D') THEN(DO)
          OPNQRYF    FILE((LENQLF2 *FIRST LENQF)) QRYSLT('NQDEPT +
                          *eq  ''' *CAT &DEPT *CAT '''') KEYFLD(*FILE)
      ENDDO
 
/* Call Profitability Report Program for Selected Criteria */
 
      CALL       PGM(LER480) PARM(&PDAT &RTYP &USAC &WSID)
      CLOF       OPNID(LENQLF2)
      DLTOVR *ALL
 
 ENDDO
 
/* If Full Report selected, call program using entire file */
 
 ELSE CMD(DO)
 
      CALL       PGM(LER480) PARM(&PDAT &RTYP &USAC &WSID)
 
 ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
 
