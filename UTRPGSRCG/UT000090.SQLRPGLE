     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UT BankFusion Data Migration Utility')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000090 - BankFusion Data Migration Utility                 *
      *                                                               *
      *  Function:  This module pushes data from midas and java error *
      *             codes tables to BF event code tables              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. AR916111A*MOVED    Date 21Feb12               *
      *  Prev Amend No. AR916111           Date 16Feb12               *
      *                 AR892580           Date 06Feb12               *
      *                 AR883210B          Date 17Jan12               *
      *                 AR883210A          Date 11Jan12               *
      *                 AR871874*REWRITE   Date 21Dec11               *
      *                 CBF011  *CREATE    Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR916111A - Additional deliveries for Error Code Data        *
      *              Migration; moved from zonal layer to global layer*
      *  AR916111 - Additional deliveries for Error Code Data         *
      *             Migration                                         *
      *  AR892580 - Warnings and Error Descriptions were not          *
      *             available and update in BFTB_EVENTCODEVIEW        *
      *  AR883210B - Additional Deliverables for BF                   *
      *  AR883210A - Additional Deliverables for BF                   *
      *  AR871874 - Screens do not display error messages             *
      *  CBF011 - BF Infrastructure: Error Message Handling           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FV_UTFINFPDIF   E           K DISK    RENAME(V_UTFINFPD:FINFF)
     F                                     PREFIX (W_)
      ** Midas Errors Input View
     FUTLCALPD  IF   E           K DISK
      ** Midas UT Locale Information File
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
 
     D***/COPY*ZACPYSRC,PSDS                                                               AR916111A
     D/COPY GPCPYSRCG,PSDS                                                                 AR916111A
 
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
     D Rcount          S              2  0
     D FinEvcd         S              8  0
     D MaxCode         S              8  0
     D MsgError        S             50
     D ErrCode         S             10
     D CatchCode       S              8  0
     D OECode          S              8  0
     D ErrDesc         S            500
     D ErrDesc2        S            500
     D DescKey         S             20
     D*MaxRRN***       S              8  0                                                  AR892580
     D AddKey          S              8
     D Schema          S             10
     D APIName         S              4
     D FldName         S             20
     D Option          S              1
     D ProcOE          S              1
     D TmpFld          S             20
     D ComLen          S             15  5
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C     *ENTRY        PLIST
     C                   PARM                    Option
     C                   PARM                    ProcOE
 
     C                   SELECT
     C     Option        WHENEQ    'C'
 
      ** Get next available event code for core
 
     C/EXEC SQL
     C**SELECT*MAX(BFEVCD)*INTO*:MaxCode*FROM*BFVW_EVCOD***************                     AR892580
     C+ SELECT MAX(BFEVCD) INTO :MaxCode FROM MIVW_EVCOD                                    AR892580
     C+ WHERE BFEVCD >= 45010000 AND BFEVCD < 45099999
     C/END-EXEC
 
      ** If no records in range
 
     C                   IF        MaxCode = 0
     C                   EVAL      FinEvcd = 45010000
 
      ** Else assign max event code value plus one
 
     C                   ELSE
     C                   EVAL      FinEvcd = MaxCode + 1
     C                   ENDIF
 
      ** If maximum range reached end program
 
     C                   IF        FinEvcd = 45099999
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     Option        WHENEQ    'F'
 
      ** Get next available event code for funded
 
     C/EXEC SQL
     C**SELECT*MAX(BFEVCD)*INTO*:MaxCode*FROM*BFVW_EVCOD***************                     AR892580
     C+ SELECT MAX(BFEVCD) INTO :MaxCode FROM MIVW_EVCOD                                    AR892580
     C+ WHERE BFEVCD >= 97500000 AND BFEVCD < 99900000
     C/END-EXEC
 
      ** If no records in range
 
     C                   IF        MaxCode = 0
     C                   EVAL      FinEvcd = 97500000
 
      ** Else assign max event code value plus one
 
     C                   ELSE
     C                   EVAL      FinEvcd = MaxCode + 1
     C                   ENDIF
 
      ** If maximum range reached end program
 
     C                   IF        FinEvcd = 99900001
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSL
 
      ***Get*maximum*relative*record*number*for*event*code*description*table                AR892580
      **********                                                                            AR892580
     C*EXEC*SQL********************************************************                     AR892580
     C**SELECT*MAX(RRN(BFTB_EVENTCODEMSG))*INTO*:MaxRRN****************                     AR892580
     C**FROM*BFTB_EVENTCODEMSG*****************************************                     AR892580
     C*END-EXEC********************************************************                     AR892580
 
      ** Read from MITB_ERRCD
 
     C                   READ      FINFF                                  89
 
      ** Process until end of file
 
     C                   DOW       *IN89 = *OFF
 
      ** Get field name from overridable errors table if applicable
 
     C                   EVAL      FldName = *BLANKS                                        AR916111
     C                   IF        W_EVFLDN = *BLANKS
     C                             AND %LEN(%TRIM(W_EVERCD)) < 11
 
     C/EXEC SQL
     C+ SELECT A2NAME INTO :FldName FROM V_GPOVCFPD
     C+ WHERE A2API = :W_EVAPIN AND
     C+ A2MSGD = :W_EVERCD
     C/END-EXEC
 
     C                   ELSE
     C                   EVAL      FldName = W_EVFLDN
 
     C                   ENDIF
 
      ** Insert new record to mapping file with event code
 
     C/EXEC SQL
     C+ INSERT INTO MITB_BFEVC
     C+ VALUES (:W_EVAPIN, :FldName, :W_EVERCD, :W_EVMSGF, :FinEvcd) WITH NC
     C/END-EXEC
 
      ** Catch if duplicate record
 
     C                   IF        SQLCODE <> -803
 
      ** Prepare Error Code
 
     C                   IF        W_EVMSGF <> *BLANKS AND
     C                             W_EVAPIN <> *BLANKS
 
     C                   EVAL      TmpFld = *BLANKS
     C                   IF        FldName = *BLANKS
     C                   EVAL      TmpFld = '*NONE'
     C                   ELSE
     C                   EVAL      TmpFld = FldName
     C                   ENDIF
     C                   EVAL      MsgError = %TRIM(W_EVAPIN) + '|' +
     C                                        %TRIM(TmpFld) + '|' +
     C                                        %TRIM(W_EVERCD)
 
     C                   ELSE
     C                   IF        W_EVAPIN <> *BLANKS                                     AR883210B
     C                   IF        FldName <> *BLANKS                                      AR883210B
     C                   EVAL      MsgError = %TRIM(W_EVAPIN) + '|' +                      AR883210B
     C                                        %TRIM(FldName) + '|' +                       AR883210B
     C                                        %TRIM(W_EVERCD)                              AR883210B
     C                   ELSE                                                              AR883210B
     C                   EVAL      MsgError = %TRIM(W_EVAPIN) + '|' +                      AR883210B
     C                                        %TRIM(W_EVERCD)                              AR883210B
     C                   ENDIF                                                             AR883210B
     C                   ELSE                                                              AR883210B
     C                   EVAL      MsgError = %TRIM(W_EVERCD)
     C                   ENDIF                                                             AR883210B
     C                   ENDIF
 
      ** Prepare error description
 
     C                   EVAL      ErrDesc = *BLANKS
     C                   EVAL      ErrDesc2 = *BLANKS
 
     C                   SELECT
 
     C     W_EVAPIN      WHENNE    *BLANKS
     C     FldName       ANDEQ     *BLANKS
     C                   EVAL      ErrDesc = %TRIM(W_EVAPIN) + '-' +
     C                             %TRIM(W_EVDESC)
 
     C     W_EVAPIN      WHENEQ    *BLANKS
     C     FldName       ANDEQ     *BLANKS
     C                   EVAL      ErrDesc = %TRIM(W_EVDESC)
 
     C     W_EVAPIN      WHENEQ    *BLANKS
     C     FldName       ANDNE     *BLANKS
     C                   EVAL      ErrDesc = %TRIM(FldName) + '-' +
     C                             %TRIM(W_EVDESC)
 
     C                   OTHER
     C                   EVAL      ErrDesc = %TRIM(W_EVAPIN) + '-' +
     C                             %TRIM(FldName) + '-' + %TRIM(W_EVDESC)
 
     C                   ENDSL
 
     ** Prepare runtime/design time error message
 
     C                   EVAL      ErrDesc2 = %TRIM(W_EVDESC)
 
      ** Insert to BFTB_EVENTCODE
 
     C/EXEC SQL
     C+ INSERT INTO BFTB_EVENTCODE
     C+ (BFEVENTCODEIDPK, BFEVENTCODENUMBER, BFDESCRIPTION, BFSEVERITY,
     C**BFCREATEDATETIME,*BFUSERCONFIGURABLE)**************************                    AR883210A
     C+ BFHANDLEABLE,  BFCOLLECTIBLE, BFISREADONLY,                                        AR883210B
     C+ BFCREATEDATETIME, BFUSERCONFIGURABLE, VERSIONNUM)                                  AR883210A
     C**VALUES*(:MsgError,*:FinEvcd,*:ErrDesc,*:W_EVSEVT,*NOW(),*0)****                    AR883210A
     C**VALUES*(:MsgError,*:FinEvcd,*:ErrDesc,*:W_EVSEVT,*NOW(),*0,*0)*          AR883210A AR883210B
     C+ VALUES (:MsgError, :FinEvcd, :ErrDesc, :W_EVSEVT, 0, 0, 0, NOW(), 0, 0)            AR883210B
     C+ WITH NC
     C/END-EXEC
 
      ** Get Locale
 
     C     *LOVAL        SETLL     UTLCALF
     C                   READ      UTLCALF                                90
 
     C                   DOW       *IN90 = *OFF
 
      ** Insert to BFTB_BFEVENTCODEMSG
 
     C**********         MOVE      MaxRRN        AddKey                                     AR892580
     C                   MOVE      FinEvcd       AddKey                                     AR892580
     C                   EVAL      DescKey = 'MI' + AddKey
 
     C/EXEC SQL
     C+ INSERT INTO BFTB_EVENTCODEMSG
     C+ (BFEVENTCODEMESSAGEIDPK, BFEVENTCODEID, BFLOCALE,
     C**BFDESIGNTIMEMESSAGE,*BFRUNTIMEMESSAGE,*BFCREATEDATETIME)*******                    AR883210A
     C+ BFDESIGNTIMEMESSAGE, BFRUNTIMEMESSAGE, BFCREATEDATETIME, VERSIONNUM)               AR883210A
     C**VALUES*(:DescKey,*:MsgError,*:LCLOCA,*:ErrDesc2,*:ErrDesc2,*NOW())                 AR883210A
     C+ VALUES (:DescKey, :MsgError, :LCLOCA, :ErrDesc2, :ErrDesc2, NOW(), 0)              AR883210A
     C+ WITH NC
     C/END-EXEC
 
     C                   READ      UTLCALF                                90
     C**********         EVAL      MaxRRN = MaxRRN + 1                                      AR892580
 
     C                   ENDDO
 
     C                   EVAL      FinEvcd = FinEvcd + 1
     C                   ENDIF
 
      ** Get Next Record
 
     C                   READ      FINFF                                  89
     C                   ENDDO
 
      ** Insert Event Code for 'no event code found'
 
     C/EXEC SQL
     C**SELECT*BFEVCD*INTO*:CatchCode*FROM*BFVW_EVCOD******************                     AR892580
     C+ SELECT BFEVCD INTO :CatchCode FROM MIVW_EVCOD                                       AR892580
     C+ WHERE BFEVCD = 45099999
     C/END-EXEC
 
     C                   IF        CatchCode = 0
                                                                                           AR883210A
     C/EXEC SQL                                                                            AR883210A
     C+ INSERT INTO MITB_BFEVC                                                             AR883210A
     C+ VALUES ('*NONE', '*NONE', '*NONE', '*NONE', 45099999) WITH NC                      AR883210A
     C/END-EXEC                                                                            AR883210A
                                                                                           AR883210A
     C/EXEC SQL
     C+ INSERT INTO BFTB_EVENTCODE
     C+ (BFEVENTCODEIDPK, BFEVENTCODENUMBER, BFDESCRIPTION, BFSEVERITY,
     C**BFCREATEDATETIME,*BFUSERCONFIGURABLE)**************************                    AR883210A
     C+ BFHANDLEABLE,  BFCOLLECTIBLE, BFISREADONLY,                                        AR883210B
     C+ BFCREATEDATETIME, BFUSERCONFIGURABLE, VERSIONNUM)                                  AR883210A
     C+ VALUES ('Event_Code_Not_Found', 45099999,
     C**'Event*Code*Not*Found',*'E',*NOW(),*0)*************************                    AR883210A
     C**'Event*Code*Not*Found',*'E',*NOW(),*0,*0)**********************          AR883210A AR883210B
     C+ 'Event Code Not Found', 'E', 0, 0, 0, NOW(), 0, 0)                                 AR883210B
     C+ WITH NC
     C/END-EXEC
 
      ** Get Locale
 
     C     *LOVAL        SETLL     UTLCALF
     C                   READ      UTLCALF                                90
 
     C                   DOW       *IN90 = *OFF
 
     C**********         MOVE      MaxRRN        AddKey                                     AR892580
     C                   MOVE      '45099999'    AddKey                                     AR892580
     C                   EVAL      DescKey = 'MI' + AddKey
 
     C/EXEC SQL
     C+ INSERT INTO BFTB_EVENTCODEMSG
     C+ (BFEVENTCODEMESSAGEIDPK, BFEVENTCODEID, BFLOCALE,
     C**BFDESIGNTIMEMESSAGE,*BFRUNTIMEMESSAGE,*BFCREATEDATETIME)*******                    AR883210A
     C+ BFDESIGNTIMEMESSAGE, BFRUNTIMEMESSAGE, BFCREATEDATETIME, VERSIONNUM)               AR883210A
     C+ VALUES (:DescKey , 'Event_Code_Not_Found', :LCLOCA,
     C**'Event*Code*Not*Found',*'Event*Code*Not*Found',*NOW())*********                    AR883210A
     C+ 'Event Code Not Found', 'Event Code Not Found', NOW(), 0)                          AR883210A
     C+ WITH NC
     C/END-EXEC
 
     C                   READ      UTLCALF                                90
     C**********         EVAL      MaxRRN = MaxRRN + 1                                      AR892580
 
     C                   ENDDO
 
     C                   ENDIF
 
      ** Process Overrideable Errors
 
     C                   EVAL      ComLen = 50
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    COMMAND
     C                   PARM                    ComLen
 
     C                   IF        ProcOE = 'Y'
     C                   EXSR      ProcessOE
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ProcessOE - Process overrideable errors to update BF Tables   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      *****************************************************************
 
     C     ProcessOE     BEGSR
 
      ** Call program to process Overridable Errors to BFTB_EVENTCODE
 
     C                   CALL      'UT000091'
 
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
