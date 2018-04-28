/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(SMC000020)  VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(CREATEZONE) HLPID(*CMD)                           */
/*EXI *  TEXT('Midas SM Create new zone')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       CREATEZONE - Create new zone for Global Processing          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSM006  *CREATE    Date 17Mar05              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSM006 - Create new zone based on existing zone.            */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Create new zone')
 
             PARM       KWD(NEWZONE) TYPE(*NAME) LEN(2) MIN(1) +
                          PROMPT('New zone prefix')
 
             PARM       KWD(GLOBLYR) TYPE(*NAME) LEN(2) MIN(1) +
                          PROMPT('Global layer prefix')
 
             PARM       KWD(BASEZONE) TYPE(*NAME) LEN(2) MIN(1) +
                          PROMPT('Based on zone prefix')
 
             PARM       KWD(ZONE) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Name of zone')
 
             PARM       KWD(ZONECODE) TYPE(*NAME) LEN(4) MIN(1) +
                          FULL(*YES) PROMPT('Zone shortcode')
 
             PARM       KWD(ZONEDESC) TYPE(*CHAR) LEN(50) MIN(1) +
                          CASE(*MIXED) PROMPT('Zone description')
