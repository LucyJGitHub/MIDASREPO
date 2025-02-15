/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER BCL Reporting - Interest to Accrue')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting                                  */
/*                                                                   */
/*       ERC0116  - Interest to accrue extract                       */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      182312  *CREATE    Date 30Oct00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       182312 - Interest to accrue not managed                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&LASTSQ)
 
/* Declare variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
             DCL        VAR(&LASTSQ) TYPE(*DEC) LEN(6 0) /* Last +
                          Record Sequence number generated */
 
/**********  OVRDBF     FILE(ERLUTRPD) SHARE(*NO)                         */              /*CER001*/
             OVRDBF     FILE(ERLTRXPD) SHARE(*NO)                                         /*CER001*/
             CALL       PGM(ERLU116) PARM(&LASTSQ)
             DLTOVR     FILE(*ALL)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited')
 
             ENDPGM
