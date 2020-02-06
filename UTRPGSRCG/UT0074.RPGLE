     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Copy data queue - copy data queue')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT0074 - Copy data queue                                     *
      *                                                               *
      *  Function:  This program copies one data queue to another     *
      *                                                               *
      *  Called By: UTC0073                                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK018             Date 24May04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CPK015  *CREATE    Date 04Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CPK018 - MidasPlus packaging.  Moved to global layer.        *
      *  CPK015 - 4.01 packaging.  New utility.                       *
      *                                                               *
      *****************************************************************
      /EJECT
     D receiver        S          64512A
     D key_data        S            256A
     D sender_data     S             44A
      *
      /SPACE 3
      *
      * Parameters passed into program.
     C     *ENTRY        PLIST
     C                   PARM                    data_queue1      10
     C                   PARM                    library1         10
     C                   PARM                    data_queue2      10
     C                   PARM                    library2         10
     C                   PARM                    message_len1      5 0
     C                   PARM                    message_len2      5 0
     C                   PARM                    key_length1       3 0
     C                   PARM                    key_length2       3 0
     C                   PARM                    no_of_messages    5 0
     C                   PARM                    dtaq_2_LIFO       4
      *
      * Set up variables.
     C                   Z-ADD     0             wait_time         5 0
     C     key_length1   IFEQ      0
     C                   MOVE      *blanks       key_order         2
     C                   ELSE
     C                   MOVE      'GE'          key_order
     C                   ENDIF
     C                   Z-ADD     0             sender_inf_len    3 0
     C                   Z-ADD     message_len1  save_msg_len1     5 0
 
     C                   MOVEL     'QTEMP'       qtemp            10
     C                   MOVEL     'TEMPDTAQ'    tempdtaq         10
     C                   MOVEL     'LIFODTAQ'    lifodtaq         10
 
      * Use number of messages to control loop.
     C                   DO        no_of_messages
      *
      * Retrieve message from first data queue.
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    data_queue1
     C                   PARM                    library1
     C                   PARM                    message_len1
     C                   PARM                    receiver
     C                   PARM                    wait_time
     C                   PARM                    key_order
     C                   PARM                    key_length1
     C                   PARM                    key_data
     C                   PARM                    sender_inf_len
     C                   PARM                    sender_data
      *
      * If message length has been set to something other than original value
      *  then re-set.
     C     message_len1  IFNE      save_msg_len1
     C                   Z-ADD     save_msg_len1 message_len1
     C                   ENDIF
      *
      * Send message to temporary copy of first data queue.
     C                   CALL      'QSNDDTAQ'
     C                   PARM                    tempdtaq
     C                   PARM                    qtemp
     C                   PARM                    message_len1
     C                   PARM                    receiver
     C                   PARM                    key_length1
     C                   PARM                    key_data
      *
      * If the second data queue is sequenced *LIFO then send message
      *  to temporary LIFO data queue.
     C     dtaq_2_LIFO   IFEQ      '*YES'
      *
      * Send message to temporary *LIFO copy of first data queue.
     C                   CALL      'QSNDDTAQ'
     C                   PARM                    lifodtaq
     C                   PARM                    qtemp
     C                   PARM                    message_len1
     C                   PARM                    receiver
     C                   PARM                    key_length1
     C                   PARM                    key_data
      *
     C                   ENDIF
      *
      * If the second data queue is not sequenced *LIFO then send message
      *  to second data queue.
     C     dtaq_2_LIFO   IFEQ      '*NO '
      *
      * Send message to second data queue.
     C                   CALL      'QSNDDTAQ'
     C                   PARM                    data_queue2
     C                   PARM                    library2
     C                   PARM                    message_len2
     C                   PARM                    receiver
     C                   PARM                    key_length2
     C                   PARM                    key_data
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Use number of messages to control loop.
     C                   DO        no_of_messages
      *
      * If keyed then set key data to blank before receiving message.
     C     key_length1   IFNE      0
     C                   MOVE      *blanks       key_data
     C                   ENDIF
      *
      * Retrieve message from temporary copy of first data queue.
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    tempdtaq
     C                   PARM                    qtemp
     C                   PARM                    message_len1
     C                   PARM                    receiver
     C                   PARM                    wait_time
     C                   PARM                    key_order
     C                   PARM                    key_length1
     C                   PARM                    key_data
     C                   PARM                    sender_inf_len
     C                   PARM                    sender_data
      *
      * If message length has been set to something other than original value
      *  then re-set.
     C     message_len1  IFNE      save_msg_len1
     C                   Z-ADD     save_msg_len1 message_len1
     C                   ENDIF
      *
      * Send message back to first data queue.
     C                   CALL      'QSNDDTAQ'
     C                   PARM                    data_queue1
     C                   PARM                    library1
     C                   PARM                    message_len1
     C                   PARM                    receiver
     C                   PARM                    key_length1
     C                   PARM                    key_data
      *
      * If the second data queue is sequenced *LIFO then additional receipt
      *  is required.
     C     dtaq_2_LIFO   IFEQ      '*YES'
      *
      * Retrieve message from temporary *LIFO copy of first data queue.
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    lifodtaq
     C                   PARM                    qtemp
     C                   PARM                    message_len1
     C                   PARM                    receiver
     C                   PARM                    wait_time
     C                   PARM                    key_order
     C                   PARM                    key_length1
     C                   PARM                    key_data
     C                   PARM                    sender_inf_len
     C                   PARM                    sender_data
      *
      * If message length has been set to something other than original value
      *  then re-set.
     C     message_len1  IFNE      save_msg_len1
     C                   Z-ADD     save_msg_len1 message_len1
     C                   ENDIF
      *
      * If the second data queue is sequenced *LIFO then send message
      *  to second data queue.
     C                   CALL      'QSNDDTAQ'
     C                   PARM                    data_queue2
     C                   PARM                    library2
     C                   PARM                    message_len2
     C                   PARM                    receiver
     C                   PARM                    key_length2
     C                   PARM                    key_data
      *
     C                   ENDIF
      *
     C                   ENDDO
 
     C                   SETON                                        LR
     C                   RETURN
      ********************************************************************
