/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 Download file to PCFILE to folder')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILDWTOPC - Create PC document wioth IBLC 2002 items         */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      200880             Date 05Dec01              */
/*                      ULX043             Date 11Oct01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       200880 - ULX043 - Narrative too long                        */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RETCOD &BCLN &FLR )
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/***  Declare variables.  ***/
 
             DCL        VAR(&RETCOD) TYPE(*CHAR) LEN(1)  VALUE(' ')
             DCL        VAR(&BCLN)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&FLR)    TYPE(*CHAR) LEN(63)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DOCNAME) TYPE(*CHAR) LEN(12)
             DCL        VAR(&MBRNAME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50) VALUE(' ')
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
 
/***  Create doc name : ABCLMMDD.TXT, BCL is BCL bank reference,  ***/
/***                                  MM  is month of reporting,  ***/
/***                                  DD  is Day of Reporting.    ***/
 
             RTVDTAARA  DTAARA(ILSTAT (2 6)) RTNVAR(&DATE)
             CHGVAR     VAR(&DOCNAME) VALUE('A' *CAT &BCLN *CAT +
                          %SST(&DATE 3 4) *CAT '.TXT')
 
/***  Create document in folder using active Bank details   ***/
 
             CHGVAR     VAR(&MBRNAME) VALUE('BCL' *CAT &BCLN)
             CPYTOPCD   FROMFILE(ILDATAPD) TOFLR(&FLR) +
                          FROMMBR(&MBRNAME) TODOC(&DOCNAME) +
                          REPLACE(*YES) TRNTBL(*DFT) TRNFMT(*TEXT)
 
/****    CHGVAR     VAR(&TEXT) VALUE('IBLC 2002 - BCL ref : ' +         200880*/
/****                     *CAT &BCLN *CAT ' at date : ' +               200880*/
/****                     *CAT %SST(&DATE 5 2) *CAT  '/'  +             200880*/
/****                     *CAT %SST(&DATE 3 2) *CAT '/20'  +            200880*/
/****                     *CAT %SST(&DATE 1 2) *CAT '.')                200880*/
             CHGVAR     VAR(&TEXT) VALUE('BCL ref : ' +
                          *CAT &BCLN *CAT ' at date : ' +
                          *CAT %SST(&DATE 5 2) *CAT  '/'  +
                          *CAT %SST(&DATE 3 2) *CAT '/20'  +
                          *CAT %SST(&DATE 1 2) *CAT '.')              /*200880*/
             CHGDOCD    DOC(&DOCNAME) FLR(&FLR) DOCD(&TEXT)
             MONMSG     MSGID(CPF0000 OFC0000)
 
/***  Leave PGM  ***/
 
             GOTO       CMDLBL(ENDPGM)
 
 ERROR:      SNDPGMMSG  MSG('Download of ILDATAPD failed during +
                          treatment of ' *CAT &BCLN *CAT ' - see +
                          dump in joblog for details') TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&RETCOD) VALUE('1')
             DMPCLPGM
 
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2005')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(ILDATAPD)
             MONMSG     MSGID(CPF0000)
             ENDPGM
