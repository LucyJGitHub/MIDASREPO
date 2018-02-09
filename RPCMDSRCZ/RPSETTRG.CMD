/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(RPC1318) VLDCKR(RPC1318_V)  MSGF(QCPFMSG)               */
/*EXI    HLPPNLGRP(RPSETTRG) HLPID(*CMD)                             */
/*EXI *  TEXT('Midas RP PB setup Meridian trigger data area')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Replication Module                                  */
/*                                                                   */
/*       RPSETTRG - Set Meridian Trigger Control Date Area.          */
/*                                                                   */
/*       Function: This command allows to set parameters that are    */
/*                 used, when starting triggering, to know where     */
/*                 to create RPTRGnn data areas, which job           */
/*                 description and job queue to use.                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CPB002  *CREATE    Date 02Mar01              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                                                                   */
/*********************************************************************/
 
             CMD        PROMPT('Set Trigger Control Data Area')
 
             PARM       KWD(DTAARALIB) TYPE(*NAME) LEN(10) +
                          PROMPT('Library for trigger data area')
 
             PARM       KWD(JOBD) TYPE(JOBD) PROMPT('Job description +
                          to be used')
 
             PARM       KWD(JOBQ) TYPE(JOBQ) PROMPT('Job queue to be used')
 
             PARM       KWD(EXIST) TYPE(*LGL) LEN(1) DSPINPUT(*NO) +
                          CHOICE(*NONE)
 
             PARM       KWD(DMLIB) TYPE(*CHAR) LEN(10) DSPINPUT(*NO) +
                           CHOICE(*NONE)
 
 JOBQ:       QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) PROMPT('Library')
 
 JOBD:       QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) PROMPT('Library')
