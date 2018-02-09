/*********************************************************************/
/*XBI    OVRMSGF MSGF(TIUSRMSG) TOMSGF(GBTIUSRMSG)                   */
/*STD    CMDBASE                                                     */
/*EXI    PGM(TIC0510)    VLDCKR(*NONE)      MSGF(TIUSRMSG)           */
/*EXI    HLPPNLGRP(RSTTICOB)    HLPID(*CMD)                          */
/*EXI *  TEXT('Midas TI Reset statuses of Midas/TI I/face CoB')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       RSTTICOB - Reset statuses of Midas/TI Interface CoB         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CTI003 *CREATE     Date 30Aug00              */
/*                      nnnnnn             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CTI003 - Midas/TI Interface CoB                             */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Reset Midas/TI I/face CoB')
 
             PARM       KWD(STRCOB) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *YES) MIN(0) +
                          PROMPT('Re-set CoB statuses to start' 1)
 
             PARM       KWD(ENDCOB) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *YES) MIN(0) +
                          PROMPT('Re-set CoB statuses to end' 1)
 
/* Both options are not allowed to be '*YES' */
             DEP        CTL(&STRCOB *EQ '*YES') PARM((&ENDCOB *NE +
                          '*YES')) MSGID(TIM0034)
