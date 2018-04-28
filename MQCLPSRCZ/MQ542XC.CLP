/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MQ RTEVENTS Generate MQ541XPF')                 */
/*********************************************************************/
/*                                                                   */
/*      Midas - Midas/Q Module                                       */
/*                                                                   */
/*      MQ542XC - Generates MQ541XPF for OPNQRYF                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CMQ001             Date 31OCT97              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CMQ001 - MidasQ rationalisation.  Override to copy of file  */
/*                created in QTEMP.                                  */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&MQID &LIST &S12 &WILD)
/**/
             DCL        VAR(&MQID) TYPE(*CHAR) LEN(8)
             DCL        VAR(&LIST) TYPE(*CHAR) LEN(3)
             DCL        VAR(&S12) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WILD) TYPE(*CHAR) LEN(3)
 
             DCL        VAR(&QRY) TYPE(*CHAR) LEN(500)
             DCL        VAR(&QRYFIL) TYPE(*CHAR) LEN(60) +
                          VALUE('OPNQRYF FILE((MQ540XLF)')
             DCL        VAR(&QRYFRMT) TYPE(*CHAR) LEN(16) +
                          VALUE('FORMAT(MQ540XLF)')
             DCL        VAR(&QRYSEL1) TYPE(*CHAR) LEN(300) +
                          VALUE('QRYSLT(''(')
             DCL        VAR(&QRYSEL2) TYPE(*CHAR) LEN(150) +
                          VALUE('*AND (')
             DCL        VAR(&EXP) TYPE(*CHAR) LEN(34) VALUE('*OR +
                          (ACODE *EQ (%WLDCRD("    ")))')
             DCL        VAR(&QRYKEY) TYPE(*CHAR) LEN(28) +
                          VALUE('KEYFLD((ACODE)) UNIQUEKEY(1)')
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/************DCLF       FILE(QTEMP/MQ544XPF)                            CMQ001*/
             DCLF       FILE(MQ544XPF)
 
/**/
/** Select From All  **/
             IF         COND(&LIST *EQ 'YES') THEN(DO)
             CHGVAR     VAR(&QRYFIL) VALUE(&QRYFIL *BCAT '(MQ542XLF)')
             CHGVAR     VAR(&QRYSEL1) VALUE(&QRYSEL1 *TCAT '(ECOD1 +
                          *EQ ACODE)')
             CHGVAR     VAR(&QRYSEL2) VALUE(&QRYSEL2 *TCAT '(MQID1 +
                          *EQ "' *TCAT &MQID *TCAT '")')
             ENDDO
 
/**/
/** Select From Characters 1 and 2  **/
             IF         COND(&S12 *EQ 'YES') THEN(DO)
             CHGVAR     VAR(&QRYFIL) VALUE(&QRYFIL *BCAT '(MQ543XLF)')
             IF         COND(&LIST *EQ 'YES') THEN(DO)
             CHGVAR     VAR(&QRYSEL1) VALUE(&QRYSEL1 *BCAT '*OR +
                          (%SST(ACODE 1 2) *EQ ECOD2)')
             CHGVAR     VAR(&QRYSEL2) VALUE(&QRYSEL2 *BCAT '*AND +
                          (MQID2 *EQ "' *TCAT &MQID *TCAT '")')
             ENDDO
             ELSE       CMD(DO)
                            CHGVAR VAR(&QRYSEL1) VALUE(&QRYSEL1 +
                          *TCAT '(%SST(ACODE 1 2) *EQ ECOD2)')
             CHGVAR     VAR(&QRYSEL2) VALUE(&QRYSEL2 *TCAT '(MQID2 +
                          *EQ "' *TCAT &MQID *TCAT '")')
             ENDDO
 
             ENDDO
 
/**/
/** Put the Closing Bracket on QRYSEL2 **/
             CHGVAR     VAR(&QRYSEL2) VALUE(&QRYSEL2 *TCAT ')')
 
/**/
/** Select From Characters Wild Card **/
             IF         COND(&WILD *EQ 'YES') THEN(DO)
 
/**/
/** If LIST and S12 Not used, then Blank Out QRYSEL2 Details **/
             IF         COND((&LIST *EQ 'NO ') *AND (&S12 *EQ 'NO +
                          ')) THEN(DO)
             CHGVAR     VAR(%SST(&EXP 1 3)) VALUE('   ')
             CHGVAR     VAR(&QRYSEL2) VALUE(' ')
             ENDDO
 
/**/
/** Ensure the correct records are picked up**/
             CPYF       FROMFILE(MQ544XPF) TOFILE(QTEMP/MQ544XPF) +
                          CRTFILE(*YES) INCCHAR(MQID3 1 *EQ &MQID)
 
/**/                                                                /* CMQ001 */
/** Override to temporary file in library QTEMP  **/                /* CMQ001 */
             OVRDBF     FILE(MQ544XPF) TOFILE(QTEMP/MQ544XPF)       /* CMQ001 */
                                                                    /* CMQ001 */
/**/
/** Get the first Wildcard Details **/
             RCVF
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&EXP 26 4)) VALUE(&ECOD3)
             CHGVAR     VAR(&QRYSEL1) VALUE(&QRYSEL1 *BCAT &EXP)
 
             CHGVAR     VAR(%SST(&EXP 1 3)) VALUE('*OR ')
 
/**/
/** Get the rest of the Wildcard Details **/
             RCVF
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))
LOOP:        CHGVAR     VAR(%SST(&EXP 26 4)) VALUE(&ECOD3)
             CHGVAR     VAR(&QRYSEL1) VALUE(&QRYSEL1 *BCAT &EXP)
 
             RCVF
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))
             GOTO       CMDLBL(LOOP)
 
 
END:         DLTF       FILE(QTEMP/MQ544XPF)
             DLTOVR     FILE(MQ544XPF)                              /* CMQ001 */
             ENDDO
 
/**/
/** Create the OPNQRYF Command **/
 
             CHGVAR     VAR(&QRY) VALUE(&QRYFIL *TCAT ')' *BCAT +
                          &QRYFRMT *BCAT &QRYSEL1 *TCAT ')' *BCAT +
                          &QRYSEL2 *TCAT ''')' *BCAT &QRYKEY)
 
/**/
/** Run the OPNQRYF Command **/
             CALL       PGM(QCMDEXC) PARM(&QRY 500)
 
/**/
/** Create the file with a CPYFRMQRYF **/
             CPYFRMQRYF FROMOPNID(MQ540XLF) TOFILE(MQ541XPF) +
                          TOMBR(&MQID) MBROPT(*REPLACE) FMTOPT(*NOCHK)
 
             CLOF       OPNID(MQ540XLF)
 
/* Change the member text to show it has been generated */
             CHGPFM     FILE(MQ541XPF) MBR(&MQID) TEXT('GEN')
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
