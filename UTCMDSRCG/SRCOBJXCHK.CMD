/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC000310)  VLDCKR(UTC000310V) MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(SRCOBJXCHK)  HLPID(*CMD)  ALWLMTUSR(*NO)          */
/*EXI *  TEXT('Midas UT Cross check source and object creation')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       SRCOBJXCHK - Cross check source and objects                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. CUT011             Date 12Dec07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK019             Date 08Jul04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CUP006 *CREATE     Date 10Jan00              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUT011 - Rewrite of command.  Make it more flexible and     */
/*                easier to maintain.                                */
/*       CPK019 - Handle global layer.                               */
/*       CUP006 - New utilities for Bridge                           */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Cross check source and objects')
 
             PARM       KWD(SRCLIB) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Source library name')
 
             PARM       KWD(GLOBAL) TYPE(GLOB) MIN(0) PROMPT('Global +
                          layer')
 
 GLOB:       ELEM       TYPE(GLOBDB) MIN(0) PROMPT('Database')
             ELEM       TYPE(GLOBND) MIN(0) PROMPT('Non-database')
 
 GLOBDB:     ELEM       TYPE(*CHAR) LEN(2) MIN(0) PROMPT('Prefix for +
                          global database')
             ELEM       TYPE(*CHAR) LEN(4) RSTD(*YES) VALUES(*GM *GP +
                          *GTA *GV) MIN(0) MAX(4) PROMPT('Database +
                          library')
             ELEM       TYPE(*NAME) LEN(10) DFT(*PFX) SPCVAL((*PFX)) +
                          PROMPT('Library for global database')
 
 GLOBND:     ELEM       TYPE(*CHAR) LEN(7) RSTD(*YES) VALUES(*DEV +
                          *CMD *OPMMOD *SRVPGM *PGM) MIN(0) MAX(5) +
                          PROMPT('Type of source')
             ELEM       TYPE(*NAME) LEN(10) MIN(0) PROMPT('Lib. for +
                          global non-db objs.')
 
             PARM       KWD(ZONE) TYPE(ZONE) MIN(0) PROMPT('Zone')
 
 ZONE:       ELEM       TYPE(ZONEDB) MIN(0) PROMPT('Database')
             ELEM       TYPE(ZONEND) MIN(0) PROMPT('Non-database')
 
 ZONEDB:     ELEM       TYPE(*CHAR) LEN(2) MIN(0) PROMPT('Prefix for +
                          zone database')
             ELEM       TYPE(*CHAR) LEN(4) RSTD(*YES) VALUES(*DM *DP +
                          *DTA *DV *DZ) MIN(0) MAX(5) PROMPT('Database +
                          library')
             ELEM       TYPE(*NAME) LEN(10) DFT(*PFX) SPCVAL((*PFX)) +
                          PROMPT('Library for zone database')
 
 ZONEND:     ELEM       TYPE(*CHAR) LEN(7) RSTD(*YES) VALUES(*DEV +
                          *CMD *OPMMOD *SRVPGM *PGM) MIN(0) MAX(5) +
                          PROMPT('Type of source')
             ELEM       TYPE(*NAME) LEN(10) MIN(0) PROMPT('Library +
                          for zone non-db objs.')
