/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0073)    VLDCKR(UTC0073_VC) MSGF(UTMSGF)             */
/*EXI    HLPPNLGRP(CPYDTAQ)    HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UT Copy one data queue to another')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       CPYDTAQ - Copy one data queue to another                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK018             Date 24May04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015 *C *CREATE  Date 28Feb02              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CPK015 - 4.01 packaging.  Move data queues to DPLIB.        */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Copy one data queue to another')
 
             PARM       KWD(FMDTAQ) TYPE(QUAL1) MIN(1) +
                          PROMPT('Data queue to be copied')
             PARM       KWD(TODTAQ) TYPE(QUAL1) MIN(1) PROMPT('Data +
                          queue to receive data')
 
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library name')
 
             PARM       KWD(COPYOPT) TYPE(*CHAR) LEN(8) RSTD(*YES) +
                          DFT(*REPLACE) VALUES(*REPLACE *ADD) +
                          PROMPT('Copy option')
 
             PARM       KWD(CRTDTAQ) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *YES) PROMPT('Create +
                          data queue')
