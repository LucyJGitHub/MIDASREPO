/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC000300)  VLDCKR(UTC000300V) MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(CRTALLOBJ)  HLPID(*CMD)  ALWLMTUSR(*NO)           */
/*EXI *  TEXT('Midas UT Create all objects from source lib')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     Utilities Module                                  */
/*                                                                   */
/*       CRTALLOBJ - Create all objects from a library containing    */
/*                     a set of Midas source files.                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. CUT011  *REWRITE   Date 18Oct07              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK018  *MOVED     Date 06Jan04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSC011             Date 23May02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 22Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAA015             DATE 07Jul96              */
/*                      10.6PK             DATE 04APR95              */
/*                      10.5PK             DATE 10MAR94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CUT011 - Rewrite of command.  Make it more flexible and     */
/*                easier to maintain.                                */
/*       CPK018 - MidasPlus packaging.  Create global layer.         */
/*       CSC011 - Introduction of DZLIB for 24x7 availability.       */
/*       CPK014 - Release 4 packaging.  DTALIB files need to be      */
/*                 created before DV files.                          */
/*       CAA015 - Remove Utilities library parameter.                */
/*       10.6PK - Release 10.06 packaging;                           */
/*              - new function added for new CRTOBJ and to cater for */
/*                more flexible library names                        */
/*              - references to BIS removed                          */
/*              - file parameter changed to a more meaningful name   */
/*              - panel group help added                             */
/*       10.5PK - Release 10.05 packaging; new function added.       */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Create multiple objects')
 
             PARM       KWD(SRCLIB) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Source library name')
 
             PARM       KWD(JOBQLIB) TYPE(QUAL1) MIN(1) PROMPT('Job +
                          queue and library')
 
             PARM       KWD(MSGFLIB) TYPE(*NAME) DFT(##GTALIB) +
                          SPCVAL((*NONE)) PROMPT('Lib. for +
                          multi-lang. msg. file')
 
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) MIN(1)
 
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
                          PROMPT('Target for global database')
             ELEM       TYPE(*NAME) LEN(10) DFT(*USER) +
                          SPCVAL((*USER)) MIN(0) PROMPT('Database +
                          owner')
             ELEM       TYPE(*NAME) LEN(10) DFT(*USE) +
                          SPCVAL((*LIBCRTAUT) (*ALL) (*CHANGE) +
                          (*USE) (*EXCLUDE) (*COMPILER)) MIN(0) +
                          PROMPT('Database *PUBLIC authority')
 
 GLOBND:     ELEM       TYPE(*CHAR) LEN(7) RSTD(*YES) VALUES(*DEV +
                          *CMD *OPMMOD *SRVPGM *PGM) MIN(0) MAX(5) +
                          PROMPT('Type of source')
             ELEM       TYPE(*NAME) LEN(10) MIN(0) PROMPT('Target +
                          for global non-db objs.')
             ELEM       TYPE(*NAME) LEN(10) DFT(*USER) +
                          SPCVAL((*USER)) MIN(0) +
                          PROMPT('Non-database owner')
             ELEM       TYPE(*NAME) LEN(10) DFT(*USE) +
                          SPCVAL((*LIBCRTAUT) (*ALL) (*CHANGE) +
                          (*USE) (*EXCLUDE) (*COMPILER)) MIN(0) +
                          PROMPT('Non-database *PUBLIC authority')
 
             PARM       KWD(ZONE) TYPE(ZONE) MIN(0) PROMPT('Zone')
 
 ZONE:       ELEM       TYPE(ZONEDB) MIN(0) PROMPT('Database')
             ELEM       TYPE(ZONEND) MIN(0) PROMPT('Non-database')
 
 ZONEDB:     ELEM       TYPE(*CHAR) LEN(2) MIN(0) PROMPT('Prefix for +
                          zone database')
             ELEM       TYPE(*CHAR) LEN(4) RSTD(*YES) VALUES(*DM *DP +
                          *DTA *DV *DZ) MIN(0) MAX(5) PROMPT('Database +
                          library')
             ELEM       TYPE(*NAME) LEN(10) DFT(*PFX) SPCVAL((*PFX)) +
                          PROMPT('Target for zone database')
             ELEM       TYPE(*NAME) LEN(10) DFT(*USER) +
                          SPCVAL((*USER)) MIN(0) PROMPT('Database +
                          owner')
             ELEM       TYPE(*NAME) LEN(10) DFT(*USE) +
                          SPCVAL((*LIBCRTAUT) (*ALL) (*CHANGE) +
                          (*USE) (*EXCLUDE) (*COMPILER)) MIN(0) +
                          PROMPT('Database *PUBLIC authority')
 
 ZONEND:     ELEM       TYPE(*CHAR) LEN(7) RSTD(*YES) VALUES(*DEV +
                          *CMD *OPMMOD *SRVPGM *PGM) MIN(0) MAX(5) +
                          PROMPT('Type of source')
             ELEM       TYPE(*NAME) LEN(10) MIN(0) PROMPT('Target +
                          for zone non-db objs.')
             ELEM       TYPE(*NAME) LEN(10) DFT(*USER) +
                          SPCVAL((*USER)) MIN(0) +
                          PROMPT('Non-database owner')
             ELEM       TYPE(*NAME) LEN(10) DFT(*USE) +
                          SPCVAL((*LIBCRTAUT) (*ALL) (*CHANGE) +
                          (*USE) (*EXCLUDE) (*COMPILER)) MIN(0) +
                          PROMPT('Non-database *PUBLIC authority')
