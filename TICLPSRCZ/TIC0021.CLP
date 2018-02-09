/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI Environment support function : routine 15')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       TIC0021 - TI Environment Support Functions: Routine 15      */
/*                 Create cross reference data area containing the   */
/*                 name of the Replication subsystem associated with */
/*                 this Midas system                                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAP005  *CREATE    Date 16Jan99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAP005 - New program                                        */
/*       N.B. Replication requires five functions from an associated */
/*       Midas system.  Four of these are provided by the CLPs       */
/*       TIC0020/23/27/29 but the fifth was not readily available.   */
/*       This new program provides that function.                    */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&UNMN &SBS)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&UNMN) TYPE(*CHAR) LEN(3) +
                           /* Unit Mnemonic = Midas prefix *CAT '1' */
             DCL        VAR(&SBS) TYPE(*CHAR) LEN(10) +
                                    /* Replication subsystem name */
             DCL        VAR(&OWN) TYPE(*CHAR) LEN(10) +
                                    /* Midas system owner */
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10) +
                                             /* TI library name */
 
/* Derive TI library name                                          */
             CHGVAR     VAR(&LIB) VALUE(%SST(&UNMN 1 2) *CAT 'TILIB')
 
/* Determine owner of Midas system                                 */
             RTVOBJD    OBJ(&LIB) OBJTYPE(*LIB) OWNER(&OWN)
 
/* Create new data arae in TI library containing the name of the   */
/*  associated Replication system                                  */
             DLTDTAARA  DTAARA(&LIB/KMDSBS)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(&LIB/KMDSBS) TYPE(*CHAR) LEN(10) +
                          VALUE(&SBS)
             MONMSG     MSGID(CPF0000)
             CHGOBJOWN  OBJ(&LIB/KMDSBS) OBJTYPE(*DTAARA) NEWOWN(&OWN)
             MONMSG     MSGID(CPF0000)
 
 
             RETURN
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
