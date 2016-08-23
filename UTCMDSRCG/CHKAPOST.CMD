/*********************************************************************/
/*STD    CMDBASEPGM                                                  */
/*EXI    PGM(UTC0019)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI *  TEXT('Midas UT Check apostrophe')                           */
/*********************************************************************/
/*                                                                   */
/*       Midas     Utilities Module                                  */
/*                                                                   */
/*       CHKAPOST - Check apostrophe                                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK018  *MOVED     Date 26Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01516             Date 18Jul94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPK018   MidasPlus packaging.  Moved to global layer.       */
/*       S01516 - Incorporation of enhanced CRTOBJ into core         */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* The Check Apostrophe command ensures that a variable either       */
/*  contains no apostrophes or that an even number is provided.      */
/*  It is specifically designed to work with parameters to be        */
/*  prompted for using QCMDEXC. If apostrophes are on the            */
/*  beginning or end of the variable, they are dropped. If a         */
/*  If a single apostrophe is found, it is doubled                   */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Insert Apostrophes')
             PARM       KWD(VAR) TYPE(*CHAR) LEN(500) MIN(1) +
                          PROMPT('Variable                 (500)')
             PARM       KWD(RTNVAR) TYPE(*CHAR) LEN(500) MIN(1) +
                          RTNVAL(*YES) +
                          PROMPT('Return Variable          (500)')
