/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IML 1.2 column 13 manager')                     */
/********************************************************************/
/*                                                                  */
/*       MIDAS/ABS EUROPEAN REPORTING                               */
/*                                                                  */
/*       ERC0121 - IML TABLE 1.2 COLUMN 13                          */
/*                                                                  */
/*       (c) Finastra International Limited 2005                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ERLDDJ DD          Date 20Mar96              */
/*                      ERL418 PT          Date 27Jul94              */
/*                      68685              Date 04Mar94             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ERLDDJ - Only extract exchange rate                        */
/*       ERL418 - Correct message text                              */
/*       68685  - IML 1.2 column 13 records generation              */
/*                                                                  */
/********************************************************************/
             PGM
 
/**********  CLRPFM     FILE(ERLU12PD)                                    */              /*CER001*/
             CLRPFM     FILE(ERL12XPD)                                                    /*CER001*/
             MONMSG     MSGID(CPF0000)
 
/************SNDMSG     MSG('IML 1.2 Accurals Extract') TOMSGQ(MRUNQ)  ERL418 */
             SNDMSG     MSG('IML 1.2 Exchange Rate Extract') +
                          TOMSGQ(MRUNQ)                              /*ERLDDJ */
 
             CALL       PGM(ERLU121)
 
             ENDPGM
