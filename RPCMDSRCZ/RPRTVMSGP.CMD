/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(RPC1305)    VLDCKR(RPC1305_V)  MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(RPRTVMSGP)  HLPID(*CMD)                           */
/*EXI *  TEXT('Midas RP PB Retrieve position in Meridian message.')  */
/*********************************************************************/
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPRTVMSGP - Retrieve position in Meridian message.          */
/*                                                                   */
/*       Function: Retrieve position of specific field or start      */
/*                 position of additionnal fields in Meridian        */
/*                 message.                                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Last Amend No. CPB002  *CREATE    Date 01Jun99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                Midas/TOF Interface.                               */
/*                                                                   */
/*********************************************************************/
 
             CMD        PROMPT('Retrieve Meridian Msg Position')
 
             PARM       KWD(PRODUCT) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Product name')
 
             PARM       KWD(IMAGE) TYPE(*CHAR) LEN(32) MIN(1) +
                          PROMPT('Record image name')
 
             PARM       KWD(FIELD) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Field name')
 
             PARM       KWD(TYPE) TYPE(*CHAR) LEN(1) DSPINPUT(*NO) +
                          PMTCTL(*PMTRQS) PROMPT('Field type')
 
             PARM       KWD(DATA) TYPE(*CHAR) LEN(4000) +
                          DSPINPUT(*NO) PMTCTL(*PMTRQS) +
                          PROMPT('Message Data')
 
             PARM       KWD(POSITION) TYPE(*CHAR) LEN(7) +
                          DSPINPUT(*NO) PMTCTL(*PMTRQS) +
                          PROMPT('Field Position')
 
             PARM       KWD(VALUE) TYPE(*CHAR) LEN(9999) +
                          DSPINPUT(*NO) PMTCTL(*PMTRQS) +
                          PROMPT('Field value')
 
             PARM       KWD(RETURNCODE) TYPE(*CHAR) LEN(10) +
                          DSPINPUT(*NO) PMTCTL(*PMTRQS) +
                          PROMPT('Return code')
