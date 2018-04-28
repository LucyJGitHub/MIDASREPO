/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI *  TEXT('Midas SM Enter options for converting branches')      */
/*E*I****PGM(SMC1091)*MSGF(UTMSGF)************************************/ /*             */ /*CUP033*/
/*EXI    PGM(SMC1092) MSGF(UTMSGF)                                   */                   /*CUP033*/
/*EXI    HLPPNLGRP(CVTBROPTN) HLPID(*CMD)                            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       CVTBROPTN - Enter options for converting branches on files  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP025 *CREATE     Date 29Jan04              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CUP025 - Change branches utility                            */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Options for Converting Brches')
 
             PARM       KWD(OPSUSFLD) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*YES) VALUES(*YES *NO) MIN(0) +
                          PROMPT('Output suspect fields?' 1)
 
             PARM       KWD(RERUN) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*YES *NO) MIN(0) +
                          PROMPT('Continue the conversion?' 2)
