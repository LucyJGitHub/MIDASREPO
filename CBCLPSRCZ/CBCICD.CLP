/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB COB read to COB ICD')                        */
/*                                                                   */
/*        Midas     - Close of Business Processing                   */
/*                                                                   */
/*       CBCICD   READ TO COB FILE SDCOBPPD                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO.                    DATE 00/00/00             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&DOMNAS1)
             DCL        VAR(&DOMNAS1) TYPE(*DEC) LEN(2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(SDCOBPPD) RCDFMT(SDCOBPD0)
/**/
/* RECEIVE THE MAXIMUM NUMBER OF ACTIVE STREAMS AVALIABLE */
/* FROM PF/SDCOBPPD */
/**/
             RCVF       RCDFMT(SDCOBPD0)
             CHGVAR     VAR(&DOMNAS1) VALUE(&DOMNAS)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
