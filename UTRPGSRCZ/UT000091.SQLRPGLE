     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UT Process Overridable Errors')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000091 - Process Overridable Errors                        *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Last Amend No. AR898346           Date 23Jan11               *
      *  Prev Amend No. AR871874 *CREATE   Date 21Dec11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR898346 - Nominate CSDU error messages as Overridable       *
      *             messages                                          *
      *  AR871874 - Screens do not display error messages             *
      *           - CBF011 - BF Infr: Error Message Handling          *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas Errors Input View
     FV_GPOVCFPDIF   E           K DISK    RENAME(V_GPOVCFPD:GPOVF)
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Data Area giving Installation Control Details

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** Program Status Data Structure
     D LDA             DS           256
      ** Local data area for database error details

     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBTXT                184    256

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D COMMAND         S              1    DIM(50) CTDATA PERRCD(50)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WRun            S              1A
     D OECode          S              8  0
     D ComLen          S             15  5

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************


     C                   READ      GPOVF                                  89

     C                   DOW       *IN89 = *OFF
     C                   EVAL      OECode = 0

     C/EXEC SQL
     C+ SELECT EVEVCD INTO :OECode FROM MIVW_BFEVC
     C+ WHERE EVAPIN = :A2API AND EVERCD = :A2MSGD AND EVFLDN = :A2NAME
     C/END-EXEC

     C                   IF        OECode <> 0
     C                             AND SQLCODE = 0

     C/EXEC SQL
     C+ UPDATE BFTB_EVENTCODE
     C**SET*BFUSERCONFIGURABLE*=*1,*BFAMENDDATETIME*=*NOW(),*BFSEVERITY*=*'E'***            AR898346
     C+ SET BFUSERCONFIGURABLE = 1, BFAMENDDATETIME = NOW(), BFSEVERITY = 'W'               AR898346
     C+ WHERE BFEVENTCODENUMBER = :OECode
     C/END-EXEC

     C                   ENDIF

     C                   READ      GPOVF                                  89
     C                   ENDDO

     C                   EVAL      ComLen = 50

     C                   CALL      'QCMDEXC'
     C                   PARM                    COMMAND
     C                   PARM                    ComLen

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP

     C                   CALL      'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR

** COMMAND
DLCOBJ OBJ((MITB_BFEVC *FILE *SHRRD))
