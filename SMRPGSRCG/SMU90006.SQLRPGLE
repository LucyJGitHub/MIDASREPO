      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Update for BFTB_ENTITLEMENTS or BFTENT')      *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  UTSM0864 - Midas SM Update for BFTB_ENTITLEMENTS or BFTENT   *
      *                                                               *
      *  Function:  This program will update the blank BFZONE of      *
      *             BFTENT (BFTB_ENTITLEMENTS) file.                  *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD059186 *CREATE     Date 11Jan22             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059186 - FM2021.B Branch entitlements cannot be removed    *
      *             from a user's role in UXP input following the     *
      *             SP2021.B upgrade because they are not shown as    *
      *             assigned.                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index                                             *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     DPSDS            SDS
      * Job name.
     D PSJobName             244    253
      * User name.
     D PSUser                254    263

     D/COPY ZACPYSRC,STD_D_SPEC


      ** Data Structure for Global Branch
     D GZSDBRCH      E DS                  EXTNAME(GZSDBRCHPD)
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PMODE           S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PERR            S             50A
     D PBRCA           S              3A
     D EntID           S             30A
     D EntType         S              6A
     D EntValue        S              3A
     D SQLStmt         S           1500A   VARYING INZ
     D SingleQoute     S              1A   INZ('''')

      /EJECT

      ** Read all records from BFTB_ENTITLEMENTS where Zone is NULL
      ** and Entitlement type is 'Branch'
     C/exec SQL
     C+ declare BFENT cursor for
     C+ select BFIDPK, BFENT00001, BFENT00002
     C+ from BFTB_ENTITLEMENTS
     C+ where BFENT00001 = 'Branch'
     C+   and BFZONE is NULL
     C/end-exec

     C/exec SQL
     C+ open BFENT
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from BFENT
     C+ into :EntID, :EntType, :EntValue
     C/end-exec

     C                   DOW       SQLCOD <> 100

     C                   IF        SQLCOD <> 0 and SQLCOD <> 100
     C                   EVAL      DBFILE = 'BFTENT'
     C                   EVAL      DBKEY  = 'BFIDK'
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      PBRCA = EntValue

      *
      ** Get zone from GZSDBRCHPD
      *
     C                   CALL      'GPACSBRCH'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      *BLANKS       PERR
     C                   PARM                    PBRCA
     C                   PARM                    GZSDBRCH
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'GZSDBRCHPD'
     C                   EVAL      DBKEY  = PBRCA
     C*    *LOCK         IN        @LDA
     C                   EXSR      *PSSR
     C                   LEAVE
     C                   ENDIF

     C                   EVAL      SQLStmt = *BLANKS

      /free
        SQLStmt = 'Update BFTB_ENTITLEMENTS set BFZONE = '
                  + SingleQoute + %trim(A8ZONE) + SingleQoute
                  + ' where BFIDPK = ' + SingleQoute + %trim(EntID)
                  + SingleQoute;
      /end-free

      ** Prepare and Execute SQL for Update on BFTB_ENTITLEMENTS
     C/exec SQL
     C+ prepare S1 from :SQLStmt
     C/end-exec

     C/exec SQL
     C+ execute S1
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from BFENT
     C+ into :EntID, :EntType, :EntValue
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close BFMG
     C/end-exec

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************

     C     *INZSR        BEGSR

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
