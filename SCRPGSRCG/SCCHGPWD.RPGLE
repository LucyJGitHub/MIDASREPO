     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SC Change user profile password')
      *****************************************************************
      *                                                               *
      *  Midas - System Control module                                *
      *                                                               *
      *  SCCHGPWD - Change user profile paswword                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG6695            Date 21Apr05               *
      *  Prev Amend No. BG4652  *CREATE    Date 29Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG6695- Password can be lower case if password level <> 0   *
      *  BG4652 - New menu option.                                    *
      *                                                               *
      *****************************************************************
     FSCCHGPWDDFCF   E             WORKSTN
      *
      * Change password API parameters.
     D ErrorCode1      S             36
      *
      * Retrieve message API parameters.
     D MessageInfoLen  S              9B 0 INZ(%Len(RTVM0100Fmt))
     D FormatName      S              8    INZ('RTVM0100')
     D ErrorMsgIDRtv   S              7
     D MessageFile     S             20    INZ('QCPFMSG   QSYS      ')
     D ErrorDataRtv    S             20
     D ReplaceDataLen  S              9B 0 INZ(%LEN(ErrorDataRtv))
     D ReplaceSubVals  S             10    INZ('*YES      ')
     D RtnFmtCtlChars  S             10    INZ('*NO       ')
     D ErrorCode2      S             36
      *                                                                                      BUG6695
      * Retrieve Security Attributes API parameters.                                         BUG6695
     D ReceiverVarLen  S              4B 0 INZ(%Len(RTSA0100Fmt))                            BUG6695
     D FormatName2     S              8    INZ('RTSA0100')                                   BUG6695
     D ErrorCode3      S             36                                                      BUG6695
      *
     D @RUN            S              1
      *
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      *
     DErrorCodeDS      DS
     D BytesProv               1      4B 0
     D BytesAvail1             5      8B 0
     D ErrorMessageID          9     15
     D Reserved               16     16
     D ErrorData              17     36
      *
     DRTVM0100Fmt      DS
     D BytesRtn                1      4B 0
     D BytesAvail2             5      8B 0
     D MsgLenRtn               9     12B 0
     D MsgLenAvail            13     16B 0
     D MsgLenHlpLen           17     20B 0
     D MsgLenHlpAvl           21     24B 0
     D Message                25    199
     D MessageHelp           200    200
      *                                                                                      BUG6695
     DRTSA0100Fmt      DS                                                                    BUG6695
     D BytesRtnd               1      4B 0                                                   BUG6695
     D BytesAvail              5      8B 0                                                   BUG6695
     D CurSecLvl               9     12B 0                                                   BUG6695
     D PndSecLvl              13     16B 0                                                   BUG6695
     D CurPwdLvl              17     20B 0                                                   BUG6695
     D PndPwdLvl              21     24B 0                                                   BUG6695
     D ChgSecSysP             25     25A                                                     BUG6695
     D AlwAddDigC             26     26A                                                     BUG6695
     D SrvTlsPwdC             27     27A                                                     BUG6695
      *
      * Set up user profile for display file.
     C                   EVAL      ##PRF = ##USR
      *                                                                                      BUG6695
      * Retrieve Security Attributes                                                         BUG6695
     C                   EVAL      ErrorCode3 = *blanks                                      BUG6695
     C                   CALL      'QSYRTVSA'                                                BUG6695
     C                   PARM                    RTSA0100Fmt                                 BUG6695
     C                   PARM                    ReceiverVarLen                              BUG6695
     C                   PARM                    FormatName2                                 BUG6695
     C                   PARM                    ErrorCode3                                  BUG6695
      *                                                                                      BUG6695
     C                   EVAL      ErrorCodeDS = ErrorCode3                                  BUG6695
      *                                                                                      BUG6695
      * If an error message is returned then retrieve the message.                           BUG6695
     C                   IF        ErrorMessageID <> ' '                                     BUG6695
     C                   EVAL      ErrorMsgIDRtv = ErrorMessageId                            BUG6695
     C                   EVAL      ErrorDataRtv = ErrorData                                  BUG6695
     C                   EXSR      RtvMessage                                                BUG6695
     C                   ENDIF                                                               BUG6695
      *
     C                   DOU       *IN10 = *OFF or
     C                             *INKC = *ON
      *                                                                                      BUG6695
     C                   If        CurPwdLvl = 0                                             BUG6695
     C                   EXFMT     SCCHGPWDD0
     C                   Else                                                                BUG6695
     C                   EXFMT     SCCHGPWDD1                                                BUG6695
     C                   Endif                                                               BUG6695
      *                                                                                      BUG6695
     C                   EVAL      *IN10 = *OFF
      *
      * If F3 has not been entered then attemmpt to change password.
     C                   IF        *INKC = *OFF
      * Check that new password and verify password match.
     C                   IF        ##NPWD <> ##VPWD
     C                   EVAL      ErrorMsgIDRtv = 'CPD2357'
     C                   EXSR      RtvMessage
     C                   ELSE
      * Call API to change password.
     C                   EVAL      ErrorCode1 = *blanks
     C                   CALL      'QSYCHGPW'
     C                   PARM                    ##PRF
     C                   PARM                    ##CPWD
     C                   PARM                    ##NPWD
     C                   PARM                    ErrorCode1
      *
     C                   EVAL      ErrorCodeDS = ErrorCode1
      *
      * If an error mesasge is returned then retrieve the message.
     C                   IF        ErrorMessageID <> ' '
     C                   EVAL      ErrorMsgIDRtv = ErrorMessageId
     C                   EVAL      ErrorDataRtv = ErrorData
     C                   EXSR      RtvMessage
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     End_Program   TAG
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  RtvMessage - Retrieves message text and variables.           *
      *                                                               *
      *  Called from: *MAIN                                           *
      *                                                               *
      *  Calls: *NONE                                                 *
      *                                                               *
      *****************************************************************
      *
     C     RtvMessage    BEGSR
      *
      * This builds the whole subfile (90 records) at once.  Entries are read
     C                   CALL      'QMHRTVM'
     C                   PARM                    RTVM0100Fmt
     C                   PARM                    MessageInfoLen
     C                   PARM                    FormatName
     C                   PARM                    ErrorMsgIDRtv
     C                   PARM                    MessageFile
     C                   PARM                    ErrorDataRtv
     C                   PARM                    ReplaceDataLen
     C                   PARM                    ReplaceSubVals
     C                   PARM                    RtnFmtCtlChars
     C                   PARM                    ErrorCode2
      * Check for API error.
     C                   EVAL      ErrorCodeDS = ErrorCode2
     C                   IF        ErrorMessageID <> ' '
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Set messsage to be displayed.
     C                   EVAL      *IN10 = *ON
     C                   EVAL      ##MSG = *blanks
     C                   EVAL      ##MSG = %SUBST(Message:1:MsgLenRtn)
     C                   EVAL      ##CPWD = *blanks
     C                   EVAL      ##NPWD = *blanks
     C                   EVAL      ##VPWD = *blanks
     C                   WRITE     SCCHGPWDD0
      *
     C     RtvMessageE   ENDSR
      *
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
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
