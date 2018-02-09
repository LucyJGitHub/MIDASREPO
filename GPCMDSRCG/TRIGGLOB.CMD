/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(GPMNTTRIG)  VLDCKR(*NONE)      MSGF(UTMSGF)             */
/*EXI    HLPPNLGRP(TRIGGERHLP)     HLPID(TRIGGERHLP)                 */
/*EXI *  TEXT('Midas GP Trigger Maintenance')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       TRIGGLOB - Triggers Maintenance                             */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGP001  *CREATE    Date 17Jun04              */
/*                      xxxxxx             Date                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGP001 - Command to invoke Trigger Maintenance programs.    */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Triggers Maintenance')
 
             PARM       KWD(ACTION) TYPE(*CHAR) LEN(12) RSTD(*YES) +
                          VALUES(*ADDTRIG *RMVTRIG *RMVALLTRIG +
                          *DSPACTIVE *DSPINACTIVE) MIN(1) +
                          PROMPT('Action:' 2)
 
             PARM       KWD(FILE) TYPE(*NAME) LEN(10) DFT(*ALL) +
                          SPCVAL((*ALL)) MIN(0) FULL(*NO) +
                          PROMPT('Filename: ' 1)
 
             PARM       KWD(TRIGTYPE) TYPE(*CHAR) LEN(9) RSTD(*YES) +
                          DFT(*LIVETRIG) VALUES(*LIVETRIG *ALLTRIG) +
                          MIN(0) PROMPT('Trigger Type: ' 3)
 
             DEP        CTL(&ACTION *EQ '*RMVALLTRIG') PARM((&FILE +
                          *NE '*ALL')) MSGID(SC00001)
 
             DEP        CTL(&ACTION *EQ '*ADDTRIG') PARM((&TRIGTYPE +
                          *NE '*ALLTRIG')) MSGID(SC00002)
