/*********************************************************************/
/*STD    CMDBASEPGM                                                  */
/*EXI    PGM(UTC0040)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(RTVJOBD)    HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UT Retrieve details from a job description')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       RTVJOBD - Retrieve details of a Job Description Command     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK018             Date 25Apr04              */
/*                      CSC017             Date 14Feb03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP001 *CREATE     Date 18Dec98              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CSC017 - Change to 250 library list.                        */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Retrieve JOBD details')
 
/*/COPY WNCPYSRC,RTVJOBDH01                                          */
 
             PARM       KWD(JOBD) TYPE(QUAL1) MIN(1) +
                          PROMPT('Job Description')
             PARM       KWD(RTNLIB) TYPE(*CHAR) LEN(10) RTNVAL(*YES) +
                          PROMPT('Return library name       (10)')
             PARM       KWD(USER) TYPE(*CHAR) LEN(10) RTNVAL(*YES) +
                          PROMPT('User name                 (10)')
             PARM       KWD(JOBQ) TYPE(*CHAR) LEN(10) RTNVAL(*YES) +
                          PROMPT('Job queue                 (10)')
             PARM       KWD(JOBQL) TYPE(*CHAR) LEN(10) RTNVAL(*YES) +
                          PROMPT('Job queue library         (10)')
             PARM       KWD(JOBPTY) TYPE(*CHAR) LEN(1) RTNVAL(*YES) +
                          PROMPT('Job priority               (1)')
             PARM       KWD(OUTPTY) TYPE(*CHAR) LEN(1) RTNVAL(*YES) +
                          PROMPT('Output priority            (1)')
             PARM       KWD(PRTDEV) TYPE(*CHAR) LEN(10) RTNVAL(*YES) +
                          PROMPT('Printer device            (10)')
             PARM       KWD(LOGCLPGM) TYPE(*CHAR) LEN(4) +
                          RTNVAL(*YES) +
                          PROMPT('Log CL program             (4)')
             PARM       KWD(ACGCDE) TYPE(*CHAR) LEN(15) RTNVAL(*YES) +
                          PROMPT('Accounting code           (15)')
             PARM       KWD(PRTTXT) TYPE(*CHAR) LEN(30) RTNVAL(*YES) +
                          PROMPT('Print text                (30)')
             PARM       KWD(RTGDTA) TYPE(*CHAR) LEN(80) RTNVAL(*YES) +
                          PROMPT('Routing data              (80)')
             PARM       KWD(RQSDTA) TYPE(*CHAR) LEN(80) RTNVAL(*YES) +
                          PROMPT('Request data              (80)')
             PARM       KWD(SYNTAX) TYPE(*CHAR) LEN(6) RTNVAL(*YES) +
                          PROMPT('Syntax check               (6)')
/************PARM       KWD(INLLIBL) TYPE(*CHAR) LEN(275) +                            */ /*CSC017*/
/************             RTNVAL(*YES) +                                               */ /*CSC017*/
/************             PROMPT('Initial lib list         (275)')                     */ /*CSC017*/
             PARM       KWD(INLLIBL) TYPE(*CHAR) LEN(2750) +
                          RTNVAL(*YES) PROMPT('Initial lib +
                          list        (2750)')
             PARM       KWD(ENDSEV) TYPE(*CHAR) LEN(2) RTNVAL(*YES) +
                          PROMPT('End severity               (2)')
             PARM       KWD(LOGLVL) TYPE(*CHAR) LEN(1) RTNVAL(*YES) +
                          PROMPT('Log level                  (1)')
             PARM       KWD(LOGSEV) TYPE(*CHAR) LEN(2) RTNVAL(*YES) +
                          PROMPT('Log message severity       (2)')
             PARM       KWD(LOGMSGTXT) TYPE(*CHAR) LEN(7) +
                          RTNVAL(*YES) +
                          PROMPT('Log message text           (7)')
             PARM       KWD(INQMSGRPY) TYPE(*CHAR) LEN(8) +
                          RTNVAL(*YES) +
                          PROMPT('Inquiry message reply      (8)')
             PARM       KWD(OUTQ) TYPE(*CHAR) LEN(10) RTNVAL(*YES) +
                          PROMPT('Output queue              (10)')
             PARM       KWD(OUTQL) TYPE(*CHAR) LEN(10) RTNVAL(*YES) +
                          PROMPT('Output queue library      (10)')
             PARM       KWD(HOLD) TYPE(*CHAR) LEN(4) RTNVAL(*YES) +
                          PROMPT('Hold job                   (4)')
             PARM       KWD(DATE) TYPE(*CHAR) LEN(8) RTNVAL(*YES) +
                          PROMPT('Job date                   (8)')
             PARM       KWD(SWS) TYPE(*CHAR) LEN(8) RTNVAL(*YES) +
                          PROMPT('Job switches               (8)')
             PARM       KWD(DEVRCYACN) TYPE(*CHAR) LEN(13) +
                          RTNVAL(*YES) +
                          PROMPT('Device recovery action    (13)')
             PARM       KWD(TSEPOOL) TYPE(*CHAR) LEN(7) RTNVAL(*YES) +
                          PROMPT('Time slice end pool        (7)')
             PARM       KWD(JOBMSGQMX) TYPE(*CHAR) LEN(7) +
                          RTNVAL(*YES) +
                          PROMPT('Job message queue max size (7)')
             PARM       KWD(JOBMSGQFL) TYPE(*CHAR) LEN(7) +
                          RTNVAL(*YES) +
                          PROMPT('Job msg queue full action  (7)')
             PARM       KWD(TEXT) TYPE(*CHAR) LEN(50) RTNVAL(*YES) +
                          PROMPT('Job description text      (50)')
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1) EXPR(*YES)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) EXPR(*YES) +
                          PROMPT('Library name')
