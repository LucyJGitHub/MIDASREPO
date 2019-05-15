/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0043)    VLDCKR(UTC0043_VC) MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(APYJOBDLBL) HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UT Apply JOBD library list to current job')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       APYJOBDLBL - Apply JOBD library list command                */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC017  *CREATE    Date 14Feb03              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC017 - Change to 250 library list.                        */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Apply JOBD Library List')
 
             PARM       KWD(JOBD) TYPE(QUAL1) MIN(1) +
                          PROMPT('Job description')
 
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1) EXPR(*YES)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) EXPR(*YES) +
                          PROMPT('Library name')
