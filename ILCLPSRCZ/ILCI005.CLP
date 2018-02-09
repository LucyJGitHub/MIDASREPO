/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 Retrieve number of record')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILCI005  - RETRIEVE NUMBER OF RECORDS                       */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX043             Date 21Aug01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
 
/***  Start Program.  ***/
 
 START:      PGM        PARM(&FILE &NRCD)
 
             DCL        VAR(&ACTCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NRCD) TYPE(*DEC) LEN(10 0)
 
             RTVMBRD    FILE(&FILE) NBRCURRCD(&NRCD)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&NRCD) VALUE(0))
 
             ENDPGM
