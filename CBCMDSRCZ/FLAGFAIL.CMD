/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(CB0501)     VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(FLAGFAIL)   HLPID(*CMD)                           */
/*EXI *  TEXT('Midas CB Flag a COB component as failed')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Close of Business Module                        */
/*                                                                   */
/*       FLAGFAIL - Flag a COB Component as Failed.                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CCB012             Date 20May02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CCB003             Date 28NOV96              */
/*                      S01517             DATE 04AUG94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCB012 - Use up to 70 job streams in close of business.     */
/*       CCB003 - CoB Performance Enhancements                       */
/*                Do not use available stream data queue for task    */
/*                split jobs as they do not appear on the screen     */
/*       S01517 - New command created to aid technicians.            */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Flag a COB Component as Failed')
 
             PARM       KWD(COMP) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Component Name:')
 
             PARM       KWD(SEQ) TYPE(*CHAR) LEN(5) MIN(1) +
                          CHOICE('00001, 10001...') +
                          PROMPT('Component Sequence:')
 
/*           PARM       KWD(STREAM) TYPE(*NAME) LEN(8) RSTD(*YES) +*/ /*CCB002*/
/*                        VALUES(STREAM00 STREAM01 STREAM02 +      */ /*CCB003*/
/*                        STREAM03 STREAM04 STREAM05 STREAM06 +    */ /*CCB003*/
/*                        STREAM07 STREAM08 STREAM09) MIN(1) +     */ /*CCB003*/
/*                        PROMPT('Component Stream:')              */ /*CCB003*/
/********    PARM       KWD(STREAM) TYPE(*NAME) LEN(8) RSTD(*YES) +            /*CCB003*/ /*CCB012*/
/********                 VALUES(STREAM00 STREAM01 STREAM02 +                  /*CCB003*/ /*CCB012*/
/********                 STREAM03 STREAM04 STREAM05 STREAM06 +                /*CCB003*/ /*CCB012*/
/********                 STREAM07 STREAM08 STREAM09 STREAMXX) +               /*CCB003*/ /*CCB012*/
/********                 MIN(1) PROMPT('Component Stream:')                   /*CCB003*/ /*CCB012*/
             PARM       KWD(STREAM) TYPE(*NAME) LEN(8) RSTD(*YES) +
                          VALUES(STREAM00 STREAM01 STREAM02 +
                          STREAM03 STREAM04 STREAM05 STREAM06 +
                          STREAM07 STREAM08 STREAM09 STREAM10 +
                          STREAM11 STREAM12 STREAM13 STREAM14 +
                          STREAM15 STREAM16 STREAM17 STREAM18 +
                          STREAM19 STREAM20 STREAM21 STREAM22 +
                          STREAM23 STREAM24 STREAM25 STREAM26 +
                          STREAM27 STREAM28 STREAM29 STREAM30 +
                          STREAM31 STREAM32 STREAM33 STREAM34 +
                          STREAM35 STREAM36 STREAM37 STREAM38 +
                          STREAM39 STREAM40 STREAM41 STREAM42 +
                          STREAM43 STREAM44 STREAM45 STREAM46 +
                          STREAM47 STREAM48 STREAM49 STREAM50 +
                          STREAM51 STREAM52 STREAM53 STREAM54 +
                          STREAM55 STREAM56 STREAM57 STREAM58 +
                          STREAM59 STREAM60 STREAM61 STREAM62 +
                          STREAM63 STREAM64 STREAM65 STREAM66 +
                          STREAM67 STREAM68 STREAM69 STREAMXX) +
                          MIN(1) PROMPT('Component Stream:')                              /*CCB012*/
 
