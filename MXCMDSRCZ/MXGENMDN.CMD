/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(MXGENMDN)     VLDCKR(MXGENMDN_V)                        */
/*EXI    HLPPNLGRP(MXGENMDN)     HLPID(*CMD )                        */
/*EXI *  TEXT('Midas MX Generate Meridian sub-message')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXGENMDN - Generate Meridian sub-message                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Last Amend No. CMX001  *CREATE    Data 01Jan00              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Export a format to Meridian')
 
             PARM       KWD(FORMAT) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Format to export')
 
             PARM       KWD(MDNNAME) TYPE(*NAME) LEN(32) DFT(*CALC) +
                          SPCVAL((*CALC)) PROMPT('Meridian +
                          (Sub)Message name')
 
             PARM       KWD(TOSTRMF) TYPE(*PNAME) LEN(5000) +
                          DFT(*CALC) SPCVAL((*CALC)) PROMPT('Stream +
                          file to write to')
 
             PARM       KWD(PREFIX) TYPE(*NAME) LEN(10) DFT(*DFT) +
                          SPCVAL((*DFT) (*FROMDBF)) PROMPT('Prefix +
                          for field names')
 
             PARM       KWD(GENTYPE) TYPE(*NAME) LEN(11) RSTD(*YES) +
                          DFT(*SUBMESSAGE) SPCVAL((*MESSAGE) +
                          (*SUBMESSAGE)) PROMPT('Gen. message or +
                          sub-message')
 
             PARM       KWD(MODE) TYPE(*NAME) LEN(7) +
                          CONSTANT(COMMAND) RSTD(*YES) VALUES(COMMAND)
 
             PARM       KWD(TYPEMATCH) TYPE(*NAME) LEN(1) DFT(Y) +
                          PROMPT('Type Match')
