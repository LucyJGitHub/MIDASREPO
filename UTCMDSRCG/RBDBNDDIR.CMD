/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC9002) VLDCKR(UTC9003)                                */
/*EXI    HLPPNLGRP(RBDBNDDIR) HLPID(RBDBNDDIR)                       */
/*EXI *  TEXT('Midas UT Rebuild binding directory')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       RBDBNDDIR - Rebuild binding directory command               */
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
/*       Prev Amend No. 141051             Date 20Aug98              */
/*                      CAP002  *CREATE    Date 04Nov97              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPK018   MidasPlus packaging.  Moved to global layer.       */
/*       141051 - Remove *LIBL support from OBJLIB parameter to      */
/*                prevent accidental binding to temporary IBM        */
/*                IBM objects.                                       */
/*       CAP002 - Conversion of Midas inputs to modular API structure*/
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Rebuild binding directory')
 
             PARM       KWD(BNDDIR) TYPE(DIRANDLIB) +
                          PROMPT('Binding directory')
 
 DIRANDLIB:  QUAL       TYPE(*NAME) DFT(MIDAS)
             QUAL       TYPE(*NAME) DFT(*USRLIBL) SPCVAL((*LIBL) +
                          (*CURLIB) (*USRLIBL)) PROMPT('Library')
 
/************PARM       KWD(OBJLIB) TYPE(*NAME) DFT(*USRLIBL)  141051 +
                          SPCVAL((*USRLIBL) (*LIBL))           141051 +
                          PROMPT('Library containing objects') 141051*/
 
             PARM       KWD(OBJLIB) TYPE(*NAME) DFT(*USRLIBL) +
                          SPCVAL((*USRLIBL)) PROMPT('Library +
                          containing objects')               /*141051*/
 
             PARM       KWD(OBJTYP) TYPE(*CHAR) LEN(7) RSTD(*YES) +
                          DFT(*BOTH) VALUES(*MODULE *SRVPGM *BOTH) +
                          PROMPT('Type of objects to include')
 
/*/COPY WNCPYSRC,mmxxxxxx01                                          */
 
