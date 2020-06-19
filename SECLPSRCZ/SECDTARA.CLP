/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Create Data Area to Monitor SE1806')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas    - Securities Trading CL Module                     */
/*                                                                   */
/*       SECDTARA - Check TRADSDX2 File                              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2007           */
/*                                                                   */
/*       LAST Amend No. 248683  *CREATE    Date 22MAY20              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       248683 -  Amended programs to check whether TRADSDX2 was    */
/*                 already written by SE1806.                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PGMNAM &WRTFLG)
             DCL        VAR(&PGMNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WRTFLG) TYPE(*CHAR) LEN(1)

/*           Check if DATA AREA SE1806FLG exists in QTEMP                     */
             CHKOBJ     OBJ(QTEMP/SE1806FLAG) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/SE1806FLAG) TYPE(*CHAR) LEN(1) +
                          TEXT('SE1806 Flag for writing to +
                          TRADSDX2') AUT(*ALL)
             ENDDO

/*           If Program Name is 'SETRADRPR' then clear data area              */
             IF         COND(&PGMNAM = 'SETRADRPR') THEN(DO)

             CHGDTAARA  DTAARA(QTEMP/SE1806FLAG (1 1)) VALUE(' ')

             ENDDO

/*           If Program Name is 'SETRADUPC' then clear data area              */
             IF         COND(&PGMNAM = 'SETRADUPC') THEN(DO)

             CHGDTAARA  DTAARA(QTEMP/SE1806FLAG (1 1)) VALUE(' ')

             ENDDO

/*           If Program Name is 'SE1806' then write value in data area        */
             IF         COND(&PGMNAM = 'SE1806') THEN(DO)

             CHGDTAARA  DTAARA(QTEMP/SE1806FLAG (1 1)) VALUE(&WRTFLG)

             ENDDO

/*           If Program Name is 'SETRADUPD' then write value in data area      */
             IF         COND(&PGMNAM = 'SETRADUPD') THEN(DO)

             RTVDTAARA  DTAARA(QTEMP/SE1806FLAG (1 1)) RTNVAR(&WRTFLG)

             ENDDO

             ENDPGM
