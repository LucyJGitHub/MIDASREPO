/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(MEC2110)   VLDCKR(*NONE)       MSGF(QCPFMSG)            */
/*EXI    PMTOVRPGM(MEC2110POP)                                       */
/*EXI    HLPPNLGRP(WRKMMMCTL)  HLPID(*CMD)                           */
/*EXI    ALLOW(*INTERACT *IPGM *IMOD *EXEC)                          */
/*EXI *  TEXT('Midas ME Work Midas Message Manager Control info')    */
/*********************************************************************/
/*                                                                   */
/*       Midas Message Management                                    */
/*                                                                   */
/*       WRKMMMCTL - Work Midas Message Manager Control info         */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CSW025  *CREATE    Date 15Apr02              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSW025 - Midas Message Manager                              */
/*                                                                   */
/*********************************************************************/
 
             CMD        PROMPT('Work Midas Msg Mgr Ctl Info')
 
             PARM       KWD(MLDBNAME) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Meridian Link database name')
 
             PARM       KWD(MDNSVRNAM) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Meridian Server name')
 
             PARM       KWD(MGNSYS) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          DFT(*YES) SPCVAL((*YES Y) (*NO N)) +
                          PROMPT('Managing Midas system?')
 
             PARM       KWD(MERIDLIB) TYPE(*NAME) LEN(10) +
                          DFT(MERIDIAN) PMTCTL(ISMGNSYS) +
                          PROMPT('Meridian managing s/w library')
 
             PARM       KWD(MDL2CASLIB) TYPE(*NAME) LEN(10) +
                          DFT(MDL2CAS) PMTCTL(ISMGNSYS) +
                          PROMPT('Meridian Link to CAS library')
 
ISMGNSYS:    PMTCTL     CTL(MGNSYS) COND((*EQ 'Y'))
